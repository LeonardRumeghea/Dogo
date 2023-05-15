using Dogo.Application.Response;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.Address
{
    public class CreateAddressCommand : IRequest<AddressResponse>
    {
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public float Latitude { get; set; }
        public float Longitude { get; set; }
        public string AdditionalDetails { get; set; }
    }
}
