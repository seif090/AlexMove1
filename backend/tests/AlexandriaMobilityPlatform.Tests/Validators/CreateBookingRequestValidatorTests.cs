using FluentValidation.TestHelper;
using AlexandriaMobilityPlatform.Application.DTOs.Booking;
using AlexandriaMobilityPlatform.Application.Validators.Booking;

namespace AlexandriaMobilityPlatform.Tests.Validators;

public class CreateBookingRequestValidatorTests
{
    private readonly CreateBookingRequestValidator _validator = new();

    [Fact]
    public void Should_Have_Error_When_GroupId_Is_Zero()
    {
        var model = new CreateBookingRequest(0, DateTime.Today.AddDays(1), null);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.GroupId);
    }

    [Fact]
    public void Should_Have_Error_When_GroupId_Is_Negative()
    {
        var model = new CreateBookingRequest(-1, DateTime.Today.AddDays(1), null);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.GroupId);
    }

    [Fact]
    public void Should_Have_Error_When_BookingDate_Is_In_Past()
    {
        var model = new CreateBookingRequest(1, DateTime.Today.AddDays(-1), null);
        var result = _validator.TestValidate(model);
        result.ShouldHaveValidationErrorFor(x => x.BookingDate);
    }

    [Fact]
    public void Should_Not_Have_Error_When_BookingDate_Is_Today()
    {
        var model = new CreateBookingRequest(1, DateTime.Today, null);
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveValidationErrorFor(x => x.BookingDate);
    }

    [Fact]
    public void Should_Not_Have_Error_When_All_Fields_Are_Valid()
    {
        var model = new CreateBookingRequest(1, DateTime.Today.AddDays(1), null);
        var result = _validator.TestValidate(model);
        result.ShouldNotHaveAnyValidationErrors();
    }
}
