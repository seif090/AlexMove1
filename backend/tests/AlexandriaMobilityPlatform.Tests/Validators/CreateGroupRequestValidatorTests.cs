using FluentValidation.TestHelper;
using AlexandriaMobilityPlatform.Application.DTOs.Group;
using AlexandriaMobilityPlatform.Application.Validators.Group;

namespace AlexandriaMobilityPlatform.Tests.Validators;

public class CreateGroupRequestValidatorTests
{
    private readonly CreateGroupRequestValidator _validator = new();

    [Fact]
    public void Should_Have_Error_When_CommunityId_Is_Zero()
    {
        var model = new CreateGroupRequest(0, 1, 1, 1, "Group A", 10, TimeSpan.FromHours(8), null, 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.CommunityId);
    }

    [Fact]
    public void Should_Have_Error_When_RouteId_Is_Zero()
    {
        var model = new CreateGroupRequest(1, 0, 1, 1, "Group A", 10, TimeSpan.FromHours(8), null, 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.RouteId);
    }

    [Fact]
    public void Should_Have_Error_When_DriverId_Is_Zero()
    {
        var model = new CreateGroupRequest(1, 1, 0, 1, "Group A", 10, TimeSpan.FromHours(8), null, 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.DriverId);
    }

    [Fact]
    public void Should_Have_Error_When_VehicleId_Is_Zero()
    {
        var model = new CreateGroupRequest(1, 1, 1, 0, "Group A", 10, TimeSpan.FromHours(8), null, 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.VehicleId);
    }

    [Fact]
    public void Should_Have_Error_When_Name_Is_Empty()
    {
        var model = new CreateGroupRequest(1, 1, 1, 1, "", 10, TimeSpan.FromHours(8), null, 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Name);
    }

    [Fact]
    public void Should_Have_Error_When_Capacity_Is_Zero()
    {
        var model = new CreateGroupRequest(1, 1, 1, 1, "Group A", 0, TimeSpan.FromHours(8), null, 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Capacity);
    }

    [Fact]
    public void Should_Have_Error_When_Capacity_Exceeds_50()
    {
        var model = new CreateGroupRequest(1, 1, 1, 1, "Group A", 51, TimeSpan.FromHours(8), null, 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Capacity);
    }

    [Fact]
    public void Should_Have_Error_When_Price_Is_Negative()
    {
        var model = new CreateGroupRequest(1, 1, 1, 1, "Group A", 10, TimeSpan.FromHours(8), null, 31, -1m);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Price);
    }

    [Fact]
    public void Should_Not_Have_Error_When_All_Fields_Are_Valid()
    {
        var model = new CreateGroupRequest(1, 1, 1, 1, "Morning Group A", 10, TimeSpan.FromHours(8), TimeSpan.FromHours(16), 31, 50m);
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveAnyValidationErrors();
    }
}
