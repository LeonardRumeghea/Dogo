using FluentValidation;

namespace Dogo.Application.Commands.User
{
    public class CreateUserCommandValidator : AbstractValidator<CreateUserCommand>
    {
        public CreateUserCommandValidator()
        {
            RuleFor(x => x.FirstName)
                .NotEmpty()
                .Length(1, 25)
                .WithMessage("First name must be between 1 and 25 characters");
            
            RuleFor(x => x.LastName)
                .NotEmpty()
                .Length(1, 25)
                .WithMessage("Last name must be between 1 and 25 characters");
            
            RuleFor(x => x.Email)
                .NotEmpty()
                .EmailAddress()
                .WithMessage("Email must be a valid email address");

            RuleFor(x => x.Password)
                .NotEmpty()
                .Length(8, 25)
                .WithMessage("Password must be between 8 and 25 characters");


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
