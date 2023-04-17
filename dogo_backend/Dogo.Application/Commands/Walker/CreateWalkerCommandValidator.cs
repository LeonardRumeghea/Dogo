using FluentValidation;

namespace Dogo.Application.Commands.Walker
{
    public class CreateWalkerCommandValidator : AbstractValidator<CreateWalkerCommand>
    {
        public CreateWalkerCommandValidator()
        {
            RuleFor(x => x.Id)
                .NotNull()
                .WithMessage("Id is required");
        }
    }
}
