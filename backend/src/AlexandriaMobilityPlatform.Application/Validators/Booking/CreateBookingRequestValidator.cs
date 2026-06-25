using FluentValidation;
using AlexandriaMobilityPlatform.Application.DTOs.Booking;

namespace AlexandriaMobilityPlatform.Application.Validators.Booking;

public class CreateBookingRequestValidator : AbstractValidator<CreateBookingRequest>
{
    public CreateBookingRequestValidator()
    {
        RuleFor(x => x.GroupId)
            .GreaterThan(0);

        RuleFor(x => x.BookingDate)
            .GreaterThanOrEqualTo(DateTime.Today);
    }
}
