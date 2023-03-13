using Dogo.Application.Commands.Pet;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class AddPetToPetOwnerQuery : IRequest<ResultOfEntity<PetResponse>>
    {
        public Guid PetOwnerId { get; set; }
        public CreatePetCommand? Pet { get; set; }
    }
}
