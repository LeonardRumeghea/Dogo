using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Commands.PetOwner
{
    public class DeletePetOwnerCommand : IRequest<HttpStatusCodeResponse>
    {
        public Guid Id { get; set; }

        public DeletePetOwnerCommand(Guid id) => Id = id;
    }
}
