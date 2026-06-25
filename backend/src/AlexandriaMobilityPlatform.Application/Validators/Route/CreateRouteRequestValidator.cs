using FluentValidation;
using AlexandriaMobilityPlatform.Application.DTOs.Route;

namespace AlexandriaMobilityPlatform.Application.Validators.Route;

public class CreateRouteRequestValidator : AbstractValidator<CreateRouteRequest>
{
    public CreateRouteRequestValidator()
    {
        RuleFor(x => x.CommunityId).GreaterThan(0);

        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(200);

        RuleFor(x => x.StartPoint)
            .NotEmpty()
            .MaximumLength(300);

        RuleFor(x => x.EndPoint)
            .NotEmpty()
            .MaximumLength(300);

        RuleFor(x => x.DistanceKm)
            .GreaterThan(0);

        RuleFor(x => x.EstimatedTimeMinutes)
            .GreaterThan(0);
    }
}
