using FluentValidation;

namespace Dogo.Application.Commands.PetOwner
{
    public class DeletePetOwnerCommandValidator : AbstractValidator<DeletePetOwnerCommand>
    {
        public DeletePetOwnerCommandValidator()
        {
            RuleFor(x => x.Id).NotEmpty().WithMessage("Id is required");
        }
    }
}
