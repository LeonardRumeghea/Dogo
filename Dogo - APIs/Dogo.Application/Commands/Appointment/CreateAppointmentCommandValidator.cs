using FluentValidation;

#nullable disable
namespace Dogo.Application.Commands.Appointment
{
    public class CreateAppointmentCommandValidator : AbstractValidator<CreateAppointmentCommand>
    {
        public CreateAppointmentCommandValidator()
        {
            RuleFor(x => x.Date)
                .NotEmpty()
                .Must(Validations.BeValidDateAppointment)
                .WithMessage("Date must be a valid date");

            RuleFor(x => x.Notes)
                .NotEmpty()
                .Length(4, 9999)
                .WithMessage("Notes must be between 4 and 9999 characters");

            RuleFor(x => x.PetId)
                .NotEmpty()
                .Must(Validations.BeValidGuid)
                .WithMessage("PetId must be a valid Guid");

            RuleFor(x => x.WalkerId)
                .NotEmpty()
                .Must(Validations.BeValidGuid)
                .WithMessage("WalkerId must be a valid Guid");
        }
    }
}
