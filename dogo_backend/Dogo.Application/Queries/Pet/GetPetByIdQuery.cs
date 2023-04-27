using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Pet
{
    public class GetPetByIdQuery : IRequest<ResultOfEntity<PetResponse>>
    {
        public Guid PetId { get; set; }
    }
}
