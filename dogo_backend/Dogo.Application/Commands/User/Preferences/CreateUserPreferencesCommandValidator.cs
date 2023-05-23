using FluentValidation;

namespace Dogo.Application.Commands.User.Preferences
{
    public class CreateUserPreferencesCommandValidator : AbstractValidator<CreateUserPreferencesCommand>
    {
        public CreateUserPreferencesCommandValidator()
        {
            RuleFor(x => x.UserId)
                .NotNull()
                .Must(Validations.BeValidGuid)
                .WithMessage("UserId is not valid");

            RuleFor(x => x.DogPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Dog preference must not be null");

            RuleFor(x => x.CatPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Cat preference must not be null");

            RuleFor(x => x.RabbitPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Rabbit preference must not be null");

            RuleFor(x => x.BirdPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Bird preference must not be null");

            RuleFor(x => x.FishPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Fish preference must not be null");

            RuleFor(x => x.FerretPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Ferret preference must not be null");

            RuleFor(x => x.GuineaPigPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Guinea pig preference must not be null");

            RuleFor(x => x.WalkPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Walk preference must not be null");

            RuleFor(x => x.VetPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Vet preference must not be null");

            RuleFor(x => x.SalonPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Salon preference must not be null");

            RuleFor(x => x.SitPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Sit preference must not be null");

            RuleFor(x => x.ShoppingPreference)
                .NotNull()
                .Must(Validations.BeValidPreference)
                .WithMessage("Shopping preference must not be null");
        }
    }
}
