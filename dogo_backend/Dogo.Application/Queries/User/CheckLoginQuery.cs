using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.User
{
    public class CheckLoginQuery : IRequest<ResultOfEntity<Core.Entities.User>>
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }
}
