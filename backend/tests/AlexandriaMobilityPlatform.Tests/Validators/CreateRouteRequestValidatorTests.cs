using FluentValidation.TestHelper;
using AlexandriaMobilityPlatform.Application.DTOs.Route;
using AlexandriaMobilityPlatform.Application.Validators.Route;

namespace AlexandriaMobilityPlatform.Tests.Validators;

public class CreateRouteRequestValidatorTests
{
    private readonly CreateRouteRequestValidator _validator = new();

    [Fact]
    public void Should_Have_Error_When_CommunityId_Is_Zero()
    {
        var model = new CreateRouteRequest(0, "Route A", "Smouha", "San Stefano", 31.2m, 29.9m, 31.25m, 29.95m, 12.5m, 30, new());
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.CommunityId);
    }

    [Fact]
    public void Should_Have_Error_When_Name_Is_Empty()
    {
        var model = new CreateRouteRequest(1, "", "Smouha", "San Stefano", 31.2m, 29.9m, 31.25m, 29.95m, 12.5m, 30, new());
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.Name);
    }

    [Fact]
    public void Should_Have_Error_When_StartPoint_Is_Empty()
    {
        var model = new CreateRouteRequest(1, "Route A", "", "San Stefano", 31.2m, 29.9m, 31.25m, 29.95m, 12.5m, 30, new());
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.StartPoint);
    }

    [Fact]
    public void Should_Have_Error_When_EndPoint_Is_Empty()
    {
        var model = new CreateRouteRequest(1, "Route A", "Smouha", "", 31.2m, 29.9m, 31.25m, 29.95m, 12.5m, 30, new());
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.EndPoint);
    }

    [Fact]
    public void Should_Have_Error_When_DistanceKm_Is_Zero()
    {
        var model = new CreateRouteRequest(1, "Route A", "Smouha", "San Stefano", 31.2m, 29.9m, 31.25m, 29.95m, 0, 30, new());
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.DistanceKm);
    }

    [Fact]
    public void Should_Have_Error_When_EstimatedTimeMinutes_Is_Zero()
    {
        var model = new CreateRouteRequest(1, "Route A", "Smouha", "San Stefano", 31.2m, 29.9m, 31.25m, 29.95m, 12.5m, 0, new());
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.EstimatedTimeMinutes);
    }

    [Fact]
    public void Should_Not_Have_Error_When_All_Fields_Are_Valid()
    {
        var model = new CreateRouteRequest(1, "Route A", "Smouha", "San Stefano", 31.2m, 29.9m, 31.25m, 29.95m, 12.5m, 30, new());
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveAnyValidationErrors();
    }
}
