using FluentValidation;

namespace Dogo.Application.Commands.PetOwner
{
    internal class CreatePetOwnerCommandValidator : AbstractValidator<CreatePetOwnerCommand>
    {
        public CreatePetOwnerCommandValidator()
        {
            RuleFor(x => x.FirstName)
                .NotEmpty()
                .Length(4, 25)
                .WithMessage("First name must be between 4 and 25 characters");
            
            RuleFor(x => x.LastName)
                .NotEmpty()
                .Length(4, 25)
                .WithMessage("Last name must be between 4 and 25 characters");
            
            RuleFor(x => x.Email)
                .NotEmpty()
                .EmailAddress()
                .WithMessage("Email must be a valid email address");
            
            RuleFor(x => x.PhoneNumber)
                .NotEmpty()
                .Length(12)
                .Matches("^\\+40\\d{9}$")
                .WithMessage("Phone number must be 12 characters");

            RuleFor(x => x.Address)
                .NotNull()
                .WithMessage("Address must not be null");
        }
    }
}
