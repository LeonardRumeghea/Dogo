using Dogo.Application.Commands.User;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.User
{
    public class UpdateUserQuery : IRequest<ResultOfEntity<UserResponse>>
    {
        public Guid Id { get; set; }
        public UpdateUserCommand PetOwner { get; set; }
}
}
