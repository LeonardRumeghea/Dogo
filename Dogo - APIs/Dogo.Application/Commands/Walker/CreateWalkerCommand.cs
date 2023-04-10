using Dogo.Application.Commands.Address;
using Dogo.Application.Response;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.Walker
{
    public class CreateWalkerCommand : IRequest<WalkerResponse>
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public CreateAddressCommand Address { get; set; }
    }
}
