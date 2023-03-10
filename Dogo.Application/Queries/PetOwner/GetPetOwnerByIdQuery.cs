using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetPetOwnerByIdQuery : IRequest<PetOwnerResponse>
    {
        public Guid Id { get; set; }
    }
}
