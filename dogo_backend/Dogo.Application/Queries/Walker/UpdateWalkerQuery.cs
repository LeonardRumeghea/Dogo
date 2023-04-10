using Dogo.Application.Commands.Walker;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class UpdateWalkerQuery : IRequest<Result>
    {
        public Guid WalkerId { get; set; }
        public UpdateWalkerCommand Walker { get; set; }
    }
}
