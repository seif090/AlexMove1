using FluentValidation;
using AlexandriaMobilityPlatform.Application.DTOs.Group;

namespace AlexandriaMobilityPlatform.Application.Validators.Group;

public class CreateGroupRequestValidator : AbstractValidator<CreateGroupRequest>
{
    public CreateGroupRequestValidator()
    {
        RuleFor(x => x.CommunityId).GreaterThan(0);
        RuleFor(x => x.RouteId).GreaterThan(0);
        RuleFor(x => x.DriverId).GreaterThan(0);
        RuleFor(x => x.VehicleId).GreaterThan(0);

        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(200);

        RuleFor(x => x.Capacity)
            .GreaterThan(0)
            .LessThanOrEqualTo(50);

        RuleFor(x => x.Price)
            .GreaterThanOrEqualTo(0);
    }
}
