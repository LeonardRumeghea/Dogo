using FluentValidation;

namespace Dogo.Application.Commands.Position
{
    public class CreatePositionCommandValidator : AbstractValidator<CreatePositionCommand>
    {
        public CreatePositionCommandValidator()
        {
            RuleFor(x => x.UserId)
                .NotEmpty()
                .WithMessage("UserId is required.");
            
            RuleFor(x => x.Latitude)
                .NotEmpty()
                .WithMessage("Latitude is required.");
            
            RuleFor(x => x.Longitude)
                .NotEmpty()
                .WithMessage("Longitude is required.");
        }
    }
}
