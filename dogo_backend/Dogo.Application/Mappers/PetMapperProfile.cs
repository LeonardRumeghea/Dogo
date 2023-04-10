using AutoMapper;
using Dogo.Application.Commands.Pet;
using Dogo.Application.Response;
using Dogo.Core.Enitities;

namespace Dogo.Application.Mappers
{
    public class PetMapperProfile : Profile
    {
        public PetMapperProfile()
        {
            CreateMap<Pet, PetResponse>().ReverseMap();
            CreateMap<Pet, CreatePetCommand>().ReverseMap();
        }
    }
}
