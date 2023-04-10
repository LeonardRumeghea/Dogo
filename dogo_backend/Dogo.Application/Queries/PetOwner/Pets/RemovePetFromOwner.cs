using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class RemovePetFromOwner : IRequest<Result>
    {
        public Guid PetOwnerId { get; set; }
        public Guid PetId { get; set; }
    }
}
