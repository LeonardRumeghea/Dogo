using FluentValidation;

#nullable disable
namespace Dogo.Application.Commands.Pet
{
    public class CreatePetCommandValidator : AbstractValidator<CreatePetCommand>
    {
        public CreatePetCommandValidator()
        {
            RuleFor(x => x.Name)
                .NotEmpty()
                .Length(2, 25)
                .WithMessage("Name must be between 2 and 25 characters");

            RuleFor(x => x.Description)
                .Length(0, 9999)
                .WithMessage("Description must be between 0 and 9999 characters");

            RuleFor(x => x.Specie)
                .NotEmpty()
                .Must(Validations.BeInSpeciesEnum)
                .WithMessage("Specie must be a valid specie");

            RuleFor(x => x.Breed)
                .NotNull()
                .Must((x, breed) => Validations.BeValidBreed(x.Specie, breed))
                .WithMessage("Breed must not be null");

            RuleFor(x => x.DateOfBirth)
                .NotEmpty()
                .Must(Validations.BeValidDateOfBirth)
                .WithMessage("DateOfBirth must be a valid date");

            RuleFor(x => x.Gender)
                .NotEmpty()
                .Must(Validations.BeInPetGenderEnum)
                .WithMessage("Gender must be a valid gender");
        }
    }
}
