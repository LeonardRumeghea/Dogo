﻿using FluentValidation;

#nullable disable
namespace Dogo.Application.Commands.Pet
{
    public class CreatePetCommandValidator : AbstractValidator<CreatePetCommand>
    {
        public CreatePetCommandValidator()
        {
            RuleFor(x => x.Name)
                .NotEmpty()
                .Length(4, 25)
                .WithMessage("Name must be between 4 and 25 characters");

            RuleFor(x => x.Description)
                .NotEmpty()
                .Length(4, 9999)
                .WithMessage("Description must be between 4 and 9999 characters");

            RuleFor(x => x.Specie)
                .NotEmpty()
                .Must(Validations.BeInSpeciesEnum)
                .WithMessage("Specie must be a valid specie");

            RuleFor(x => x.Breed)
                .NotNull()
                .Must((x, breed) => Validations.BeRightBreed(x.Specie, breed))
                .WithMessage("Breed must not be null");

            RuleFor(x => x.DateOfBirth)
                .NotEmpty()
                .Must(Validations.BeValidDate)
                .WithMessage("DateOfBirth must be a valid date");

            RuleFor(x => x.Gender)
                .NotEmpty()
                .Must(Validations.BeInPetGenderEnum)
                .WithMessage("Gender must be a valid gender");
        }
    }
}