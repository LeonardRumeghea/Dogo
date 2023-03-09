using Dogo.Application.Commands.Pet;
using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class AddPetToPetOwnerQuery : IRequest<HttpStatusCodeResponse>
    {
        public Guid PetOwnerId { get; set; }
        public CreatePetCommand? Pet { get; set; }
    }
}
