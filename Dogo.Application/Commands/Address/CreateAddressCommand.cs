using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Commands.Address
{
    public class CreateAddressCommand : IRequest<AddressResponse>
    {
        public string? Street { get; set; }
        public int? Number { get; set; }
        public string? City { get; set; }
        public string? State { get; set; }
        public string? ZipCode { get; set; }
    }
}
