using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class RemovePetFromOwner : IRequest<HttpStatusCode>
    {
        public Guid PetOwnerId { get; set; }
        public Guid PetId { get; set; }
    }
}
