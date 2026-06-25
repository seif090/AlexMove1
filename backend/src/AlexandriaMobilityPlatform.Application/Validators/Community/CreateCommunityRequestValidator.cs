using FluentValidation;
using AlexandriaMobilityPlatform.Application.DTOs.Community;

namespace AlexandriaMobilityPlatform.Application.Validators.Community;

public class CreateCommunityRequestValidator : AbstractValidator<CreateCommunityRequest>
{
    public CreateCommunityRequestValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(200);

        RuleFor(x => x.Type)
            .NotEmpty()
            .MaximumLength(50);

        RuleFor(x => x.City)
            .NotEmpty()
            .MaximumLength(100);

        RuleFor(x => x.Area)
            .NotEmpty()
            .MaximumLength(100);

        RuleFor(x => x.Address)
            .NotEmpty()
            .MaximumLength(500);
    }
}
