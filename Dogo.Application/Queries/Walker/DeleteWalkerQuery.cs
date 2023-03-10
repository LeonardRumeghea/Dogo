using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class DeleteWalkerQuery : IRequest
    {
        public Guid Id { get; set; }
    }
}
