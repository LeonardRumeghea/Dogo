using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class GetWalkerByIdQuery : IRequest<WalkerResponse?>
    {
        public Guid Id { get; set; }
    }
}
