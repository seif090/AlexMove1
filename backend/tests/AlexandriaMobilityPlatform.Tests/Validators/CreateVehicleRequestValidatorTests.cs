using FluentValidation.TestHelper;
using AlexandriaMobilityPlatform.Application.DTOs.Vehicle;
using AlexandriaMobilityPlatform.Application.Validators.Vehicle;

namespace AlexandriaMobilityPlatform.Tests.Validators;

public class CreateVehicleRequestValidatorTests
{
    private readonly CreateVehicleRequestValidator _validator = new();

    [Fact]
    public void Should_Have_Error_When_DriverId_Is_Zero()
    {
        var model = new CreateVehicleRequest(0, "ABC-123", "Toyota Camry", "White", 4, 2022);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.DriverId);
    }

    [Fact]
    public void Should_Have_Error_When_PlateNumber_Is_Empty()
    {
        var model = new CreateVehicleRequest(1, "", "Toyota Camry", "White", 4, 2022);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.PlateNumber);
    }

    [Fact]
    public void Should_Have_Error_When_Model_Is_Empty()
    {
        var model = new CreateVehicleRequest(1, "ABC-123", "", "White", 4, 2022);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Model);
    }

    [Fact]
    public void Should_Have_Error_When_Color_Is_Empty()
    {
        var model = new CreateVehicleRequest(1, "ABC-123", "Toyota Camry", "", 4, 2022);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Color);
    }

    [Fact]
    public void Should_Have_Error_When_Capacity_Is_Zero()
    {
        var model = new CreateVehicleRequest(1, "ABC-123", "Toyota Camry", "White", 0, 2022);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Capacity);
    }

    [Fact]
    public void Should_Have_Error_When_Capacity_Exceeds_50()
    {
        var model = new CreateVehicleRequest(1, "ABC-123", "Toyota Camry", "White", 51, 2022);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Capacity);
    }

    [Fact]
    public void Should_Have_Error_When_Year_Is_Before_2000()
    {
        var model = new CreateVehicleRequest(1, "ABC-123", "Toyota Camry", "White", 4, 1999);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Year);
    }

    [Fact]
    public void Should_Have_Error_When_Year_Is_In_Far_Future()
    {
        var model = new CreateVehicleRequest(1, "ABC-123", "Toyota Camry", "White", 4, DateTime.Now.Year + 2);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Year);
    }

    [Fact]
    public void Should_Not_Have_Error_When_All_Fields_Are_Valid()
    {
        var model = new CreateVehicleRequest(1, "ABC-123", "Toyota Camry", "White", 4, 2022);
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveAnyValidationErrors();
    }
}
