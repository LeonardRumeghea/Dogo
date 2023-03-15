using FluentValidation;

namespace Dogo.Application.Commands.Review
{
    public class CreateReviewCommandValidator : AbstractValidator<CreateReviewCommand>
    {
        public CreateReviewCommandValidator()
        {
            RuleFor(x => x.Comment)
                .MaximumLength(500)
                .WithMessage("Comment is required");

            RuleFor(x => x.Rating)
                .NotEmpty()
                .GreaterThan(0)
                .LessThanOrEqualTo(5)
                .WithMessage("Rating is required");
            
            RuleFor(x => x.AppointmentId)
                .NotEmpty()
                .Must(x => x != Guid.Empty)
                .Must(Validations.BeValidGuid)
                .WithMessage("AppointmentId is required");

            RuleFor(x => x.WrittenBy)
                .NotEmpty()
                .Must(x => x != Guid.Empty)
                .Must(Validations.BeValidGuid)
                .WithMessage("WrittenBy Id is required");
        }
    }
}
