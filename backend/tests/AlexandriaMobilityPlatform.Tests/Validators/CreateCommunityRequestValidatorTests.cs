using FluentValidation.TestHelper;
using AlexandriaMobilityPlatform.Application.DTOs.Community;
using AlexandriaMobilityPlatform.Application.Validators.Community;

namespace AlexandriaMobilityPlatform.Tests.Validators;

public class CreateCommunityRequestValidatorTests
{
    private readonly CreateCommunityRequestValidator _validator = new();

    [Fact]
    public void Should_Have_Error_When_Name_Is_Empty()
    {
        var model = new CreateCommunityRequest("", "Residential", "Alexandria", "Smouha", "123 Main St");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Name);
    }

    [Fact]
    public void Should_Have_Error_When_Name_Exceeds_Max_Length()
    {
        var model = new CreateCommunityRequest(new string('A', 201), "Residential", "Alexandria", "Smouha", "123 Main St");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Name);
    }

    [Fact]
    public void Should_Have_Error_When_Type_Is_Empty()
    {
        var model = new CreateCommunityRequest("Test Community", "", "Alexandria", "Smouha", "123 Main St");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Type);
    }

    [Fact]
    public void Should_Have_Error_When_City_Is_Empty()
    {
        var model = new CreateCommunityRequest("Test Community", "Residential", "", "Smouha", "123 Main St");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.City);
    }

    [Fact]
    public void Should_Have_Error_When_Area_Is_Empty()
    {
        var model = new CreateCommunityRequest("Test Community", "Residential", "Alexandria", "", "123 Main St");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Area);
    }

    [Fact]
    public void Should_Have_Error_When_Address_Is_Empty()
    {
        var model = new CreateCommunityRequest("Test Community", "Residential", "Alexandria", "Smouha", "");
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Address);
    }

    [Fact]
    public void Should_Not_Have_Error_When_All_Fields_Are_Valid()
    {
        var model = new CreateCommunityRequest("Alexandria Tech Hub", "Residential", "Alexandria", "Smouha", "123 Main St");
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveAnyValidationErrors();
    }
}
