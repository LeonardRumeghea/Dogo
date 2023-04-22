using AutoMapper;
using Dogo.Application.Commands.Address;
using Dogo.Application.Response;
using Dogo.Core.Entities;

namespace Dogo.Application.Mappers
{
    public class AddressMapperProfile : Profile
    {
        public AddressMapperProfile()
        {
            CreateMap<Address, AddressResponse>().ReverseMap();
            CreateMap<Address, CreateAddressCommand>().ReverseMap();
        }
    }
}
