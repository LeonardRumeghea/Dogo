using FluentValidation;

namespace Dogo.Application.Commands.Appointment
{
    public class UpdateAppointmentCommandValidator : AbstractValidator<UpdateAppointmentCommand>
    {
        public UpdateAppointmentCommandValidator()
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
        }
    }
}
