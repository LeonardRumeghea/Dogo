using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.User
{
    public class GetAllUsersQuery : IRequest<List<UserResponse>> { }
}
