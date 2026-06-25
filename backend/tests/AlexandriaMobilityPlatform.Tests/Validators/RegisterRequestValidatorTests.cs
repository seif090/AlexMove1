using FluentValidation.TestHelper;
using AlexandriaMobilityPlatform.Application.DTOs.Auth;
using AlexandriaMobilityPlatform.Application.Validators.Auth;

namespace AlexandriaMobilityPlatform.Tests.Validators;

public class RegisterRequestValidatorTests
{
    private readonly RegisterRequestValidator _validator = new();

    [Fact]
    public void Should_Have_Error_When_FullName_Is_Empty()
    {
        var model = new RegisterRequestDto("", "test@test.com", "+1234567890", "Password1!");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.FullName);
    }

    [Fact]
    public void Should_Have_Error_When_Email_Is_Invalid()
    {
        var model = new RegisterRequestDto("John", "not-an-email", "+1234567890", "Password1!");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Email);
    }

    [Fact]
    public void Should_Have_Error_When_PhoneNumber_Is_Invalid()
    {
        var model = new RegisterRequestDto("John", "test@test.com", "123", "Password1!");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.PhoneNumber);
    }

    [Fact]
    public void Should_Have_Error_When_Password_Is_Too_Short()
    {
        var model = new RegisterRequestDto("John", "test@test.com", "+1234567890", "Ab1!");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Password);
    }

    [Fact]
    public void Should_Have_Error_When_Password_Missing_Uppercase()
    {
        var model = new RegisterRequestDto("John", "test@test.com", "+1234567890", "password1!");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Password);
    }

    [Fact]
    public void Should_Have_Error_When_Password_Missing_Digit()
    {
        var model = new RegisterRequestDto("John", "test@test.com", "+1234567890", "Password!");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Password);
    }

    [Fact]
    public void Should_Have_Error_When_Password_Missing_SpecialChar()
    {
        var model = new RegisterRequestDto("John", "test@test.com", "+1234567890", "Password1");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Password);
    }

    [Fact]
    public void Should_Have_Error_When_PreferredLanguage_Is_Invalid()
    {
        var model = new RegisterRequestDto("John", "test@test.com", "+1234567890", "Password1!", "fr");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.PreferredLanguage);
    }

    [Fact]
    public void Should_Not_Have_Error_When_All_Fields_Are_Valid()
    {
        var model = new RegisterRequestDto("John Doe", "test@test.com", "+1234567890", "Password1!");
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveAnyValidationErrors();
    }

    [Fact]
    public void Should_Not_Have_Error_When_PreferredLanguage_Is_Arabic()
    {
        var model = new RegisterRequestDto("John", "test@test.com", "+1234567890", "Password1!", "ar");
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveValidationErrorFor(x => x.PreferredLanguage);
    }
}
