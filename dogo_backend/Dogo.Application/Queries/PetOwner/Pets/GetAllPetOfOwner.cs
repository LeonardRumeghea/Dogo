using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class GetAllPetOfOwner : IRequest<List<PetResponse>>
    {
        public Guid PetOwnerId { get; set; }
    }
}
