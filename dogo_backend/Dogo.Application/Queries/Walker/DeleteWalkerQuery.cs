using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class DeleteWalkerQuery : IRequest<Result>
    {
        public Guid Id { get; set; }
    }
}
