using AutoMapper;
using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Response;
using Dogo.Core.Enitities;

namespace Dogo.Application.Mappers
{
    public class PersonMapperProfile : Profile
    {
        public PersonMapperProfile()
        {
            CreateMap<Person, PersonResponse>().ReverseMap();
            CreateMap<Person, CreatePetOwnerCommand>().ReverseMap();
        }
    }
}
