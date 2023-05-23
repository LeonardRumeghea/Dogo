using FluentValidation;

#nullable disable
namespace Dogo.Application.Commands.Appointment
{
    public class CreateAppointmentCommandValidator : AbstractValidator<CreateAppointmentCommand>
    {
        public CreateAppointmentCommandValidator()
        {
            RuleFor(x => x.DateWhen)
                .NotEmpty()
                .Must(Validations.BeValidAppointmentDate)
                .WithMessage("Date must be a valid date");

            RuleFor(x => x.DateUntil)
                .Must(Validations.BeValidUntilDateAppointment)
                .WithMessage("Date must be a valid date");

            RuleFor(x => x.Notes)
                .Length(0, 9999)
                .WithMessage("Notes must be between 0 and 9999 characters");

            RuleFor(x => x.PetId)
                .NotEmpty()
                .Must(Validations.BeValidGuid)
                .WithMessage("PetId must be a valid Guid");
        
            RuleFor(x => x.Duration)
                .Must(Validations.BeValidAppointmentDuration)
                .WithMessage("Duration must be a valid duration between 1 and 1440 minutes");

            RuleFor(x => x.Type)
                .NotEmpty()
                .Must(Validations.BeValidAppointmentType)
                .WithMessage("Type must be a valid AppointmentType");
        }
    }
}
