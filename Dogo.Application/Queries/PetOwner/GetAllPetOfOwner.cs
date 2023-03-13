using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetAllPetOfOwner : IRequest<List<PetResponse>>
    {
        public Guid PetOwnerId { get; set; }
    }
}
