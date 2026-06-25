using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Auth;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class AuthService : IAuthService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IConfiguration _configuration;
    private readonly IDateTime _dateTime;
    private readonly IApplicationDbContext _context;

    public AuthService(
        UserManager<ApplicationUser> userManager,
        IConfiguration configuration,
        IDateTime dateTime,
        IApplicationDbContext context)
    {
        _userManager = userManager;
        _configuration = configuration;
        _dateTime = dateTime;
        _context = context;
    }

    public async Task<Result<AuthResponseDto>> RegisterAsync(RegisterRequestDto request, CancellationToken cancellationToken = default)
    {
        var existingUser = await _userManager.FindByEmailAsync(request.Email);
        if (existingUser != null)
            return Result<AuthResponseDto>.Failure("Email already registered");

        var user = new ApplicationUser
        {
            UserName = request.Email,
            Email = request.Email,
            PhoneNumber = request.PhoneNumber,
            FullName = request.FullName,
            PreferredLanguage = request.PreferredLanguage ?? "en",
            IsActive = true,
            EmailConfirmed = true,
            PhoneNumberConfirmed = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        var result = await _userManager.CreateAsync(user, request.Password);
        if (!result.Succeeded)
            return Result<AuthResponseDto>.Failure(result.Errors.Select(e => e.Description).ToList());

        await _userManager.AddToRoleAsync(user, "Passenger");

        return await GenerateAuthResponseAsync(user);
    }

    public async Task<Result<AuthResponseDto>> LoginAsync(LoginRequestDto request, CancellationToken cancellationToken = default)
    {
        var user = await _userManager.FindByEmailAsync(request.Email);
        if (user == null || !await _userManager.CheckPasswordAsync(user, request.Password))
            return Result<AuthResponseDto>.Failure("Invalid email or password");

        if (!user.IsActive)
            return Result<AuthResponseDto>.Failure("Account is deactivated");

        return await GenerateAuthResponseAsync(user);
    }

    public async Task<Result<AuthResponseDto>> RefreshTokenAsync(RefreshTokenRequestDto request, CancellationToken cancellationToken = default)
    {
        var principal = GetPrincipalFromExpiredToken(request.Token);
        if (principal == null)
            return Result<AuthResponseDto>.Failure("Invalid token");

        var userId = long.Parse(principal.FindFirstValue(ClaimTypes.NameIdentifier)!);
        var user = await _userManager.FindByIdAsync(userId.ToString());
        if (user == null)
            return Result<AuthResponseDto>.Failure("User not found");

        var storedToken = await _context.RefreshTokens
            .FirstOrDefaultAsync(rt => rt.Token == request.RefreshToken && rt.UserId == userId && rt.RevokedAt == null, cancellationToken);

        if (storedToken == null || storedToken.ExpiresAt < _dateTime.UtcNow)
            return Result<AuthResponseDto>.Failure("Invalid or expired refresh token");

        storedToken.RevokedAt = _dateTime.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);

        return await GenerateAuthResponseAsync(user);
    }

    public async Task<Result> RevokeTokenAsync(string refreshToken, CancellationToken cancellationToken = default)
    {
        var token = await _context.RefreshTokens.FirstOrDefaultAsync(rt => rt.Token == refreshToken, cancellationToken);
        if (token == null) return Result.Failure("Token not found");
        token.RevokedAt = _dateTime.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Token revoked");
    }

    private async Task<Result<AuthResponseDto>> GenerateAuthResponseAsync(ApplicationUser user)
    {
        var roles = await _userManager.GetRolesAsync(user);
        var token = GenerateJwtToken(user, roles);
        var refreshToken = await GenerateRefreshTokenAsync(user.Id);

        var response = new AuthResponseDto(
            token,
            refreshToken.Token,
            new UserProfileDto(user.Id, user.FullName, user.Email ?? "", user.PhoneNumber ?? "", user.ProfileImageUrl, user.PreferredLanguage ?? "en"),
            DateTime.UtcNow.AddMinutes(Convert.ToDouble(_configuration["JwtSettings:ExpirationInMinutes"] ?? "60")));

        return Result<AuthResponseDto>.Success(response);
    }

    private string GenerateJwtToken(ApplicationUser user, IList<string> roles)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JwtSettings:SecretKey"]!));
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new(ClaimTypes.Email, user.Email!),
            new(ClaimTypes.Name, user.FullName),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };
        claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));

        var token = new JwtSecurityToken(
            issuer: _configuration["JwtSettings:Issuer"],
            audience: _configuration["JwtSettings:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(Convert.ToDouble(_configuration["JwtSettings:ExpirationInMinutes"] ?? "60")),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256));

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    private async Task<RefreshToken> GenerateRefreshTokenAsync(long userId)
    {
        var refreshToken = new RefreshToken
        {
            UserId = userId,
            Token = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64)),
            ExpiresAt = _dateTime.UtcNow.AddDays(Convert.ToDouble(_configuration["JwtSettings:RefreshExpirationInDays"] ?? "7")),
            CreatedAt = _dateTime.UtcNow
        };
        _context.RefreshTokens.Add(refreshToken);
        await _context.SaveChangesAsync();
        return refreshToken;
    }

    private ClaimsPrincipal? GetPrincipalFromExpiredToken(string token)
    {
        var tokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = false,
            ValidateIssuerSigningKey = true,
            ValidIssuer = _configuration["JwtSettings:Issuer"],
            ValidAudience = _configuration["JwtSettings:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JwtSettings:SecretKey"]!))
        };
        var tokenHandler = new JwtSecurityTokenHandler();
        try
        {
            var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);
            if (securityToken is not JwtSecurityToken jwtToken || !jwtToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
                return null;
            return principal;
        }
        catch { return null; }
    }
}
