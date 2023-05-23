using Dogo.Application.Commands.Address;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.User
{
    public class CreateUserCommand : IRequest<ResultOfEntity<UserResponse>>
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string PhoneNumber { get; set; }
        public CreateAddressCommand Address { get; set; }
    }
}
