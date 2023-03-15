using FluentValidation;

namespace Dogo.Application.Commands.Walker
{
    public class UpdateWalkerCommandValidator : AbstractValidator<UpdateWalkerCommand>
    {
        public UpdateWalkerCommandValidator()
        {
            RuleFor(x => x.FirstName)
                .NotEmpty()
                .MinimumLength(4)
                .MaximumLength(100)
                .WithMessage("FirstName is required");

            RuleFor(x => x.LastName)
                .NotEmpty()
                .MinimumLength(4)
                .MaximumLength(100)
                .WithMessage("LastName is required");

            RuleFor(x => x.Email)
                .NotEmpty()
                .MaximumLength(100)
                .EmailAddress()
                .WithMessage("Email is required");

            RuleFor(x => x.PhoneNumber)
                .NotEmpty()
                .MaximumLength(12)
                .Matches("^\\+40\\d{9}$")
                .WithMessage("PhoneNumber is required");

            RuleFor(x => x.Address)
                .NotNull()
                .WithMessage("Address is required");
        }
    }
}
