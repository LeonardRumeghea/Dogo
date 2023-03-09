using MediatR;

namespace Dogo.Application.Commands.PetOwner
{
    public class DeletePetOwnerCommand : IRequest<bool>
    {
        public Guid Id { get; set; }

        public DeletePetOwnerCommand(Guid id) => Id = id;
    }
}
