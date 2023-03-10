using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class GetAllWalkersQuery : IRequest<List<WalkerResponse>> { }
}
