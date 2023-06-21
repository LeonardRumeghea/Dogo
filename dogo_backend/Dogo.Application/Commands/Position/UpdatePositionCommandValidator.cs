using FluentValidation;

namespace Dogo.Application.Commands.Position
{
    public class UpdatePositionCommandValidator : AbstractValidator<UpdatePositionCommand>
    {
        public UpdatePositionCommandValidator()
        {
            RuleFor(x => x.UserId).NotEmpty().WithMessage("UserId is required.");
            RuleFor(x => x.Latitude).NotEmpty().WithMessage("Latitude is required.");
            RuleFor(x => x.Longitude).NotEmpty().WithMessage("Longitude is required.");
        }
    }
}
