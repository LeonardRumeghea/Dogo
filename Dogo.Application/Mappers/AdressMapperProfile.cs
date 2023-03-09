using AutoMapper;
using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Response;
using Dogo.Core.Enitities;

namespace Dogo.Application.Mappers
{
    public class AdressMapperProfile : Profile
    {
        public AdressMapperProfile()
        {
            CreateMap<Address, AdressResponse>().ReverseMap();
        }
    }
}
