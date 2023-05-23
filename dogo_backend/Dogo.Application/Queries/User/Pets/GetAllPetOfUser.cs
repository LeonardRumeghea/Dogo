using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class GetAllPetOfUser : IRequest<List<PetResponse>>
    {
        public Guid PetOwnerId { get; set; }
    }
}
