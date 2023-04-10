using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetPetOwnerByIdQuery : IRequest<ResultOfEntity<PetOwnerResponse>>
    {
        public Guid Id { get; set; }
    }
}
