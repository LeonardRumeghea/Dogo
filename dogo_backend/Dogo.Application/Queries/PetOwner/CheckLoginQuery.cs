using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class CheckLoginQuery : IRequest<ResultOfEntity<Core.Entities.PetOwner>>
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }
}
