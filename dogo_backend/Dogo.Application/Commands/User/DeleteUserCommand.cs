using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Commands.User
{
    public class DeleteUserCommand : IRequest<HttpStatusCode>
    {
        public Guid Id { get; set; }

        public DeleteUserCommand(Guid id) => Id = id;
    }
}
