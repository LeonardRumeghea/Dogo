using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class GetPetByIdQuery : IRequest<ResultOfEntity<PetResponse>>
    {
        public Guid PetOwnerId { get; set; }
        public Guid PetId { get; set; }
    }
}
