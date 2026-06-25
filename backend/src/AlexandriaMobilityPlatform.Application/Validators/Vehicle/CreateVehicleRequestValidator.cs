using FluentValidation;
using AlexandriaMobilityPlatform.Application.DTOs.Vehicle;

namespace AlexandriaMobilityPlatform.Application.Validators.Vehicle;

public class CreateVehicleRequestValidator : AbstractValidator<CreateVehicleRequest>
{
    public CreateVehicleRequestValidator()
    {
        RuleFor(x => x.DriverId)
            .GreaterThan(0);

        RuleFor(x => x.PlateNumber)
            .NotEmpty()
            .MaximumLength(50);

        RuleFor(x => x.Model)
            .NotEmpty()
            .MaximumLength(100);

        RuleFor(x => x.Color)
            .NotEmpty()
            .MaximumLength(50);

        RuleFor(x => x.Capacity)
            .GreaterThan(0)
            .LessThanOrEqualTo(50);

        RuleFor(x => x.Year)
            .InclusiveBetween(2000, DateTime.Now.Year + 1);
    }
}
