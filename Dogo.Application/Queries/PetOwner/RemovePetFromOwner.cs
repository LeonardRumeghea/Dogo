using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class RemovePetFromOwner : IRequest<HttpStatusCodeResponse>
    {
        public Guid PetOwnerId { get; set; }
        public Guid PetId { get; set; }
    }
}
