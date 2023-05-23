using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.User
{
    public class GetUserByIdQuery : IRequest<ResultOfEntity<UserResponse>>
    {
        public Guid Id { get; set; }
    }
}
