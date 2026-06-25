using FluentValidation;
using AlexandriaMobilityPlatform.Application.DTOs.Auth;

namespace AlexandriaMobilityPlatform.Application.Validators.Auth;

public class LoginRequestValidator : AbstractValidator<LoginRequestDto>
{
    public LoginRequestValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress();

        RuleFor(x => x.Password)
            .NotEmpty();
    }
}
