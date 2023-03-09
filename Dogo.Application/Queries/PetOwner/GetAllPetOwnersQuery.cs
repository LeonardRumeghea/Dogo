using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetAllPetOwnersQuery : IRequest<List<PetOwnerResponse>> { }
}
