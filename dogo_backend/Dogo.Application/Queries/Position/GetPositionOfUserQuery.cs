using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Position
{
    public class GetPositionOfUserQuery : IRequest<ResultOfEntity<PositionResponse>>
    {
        public Guid UserId { get; set; }
    }
}
