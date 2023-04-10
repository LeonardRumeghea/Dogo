using AutoMapper;
using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Response;
using Dogo.Core.Enitities;

namespace Dogo.Application.Mappers
{
    public class PetOwnerMapperProfile : Profile
    {
        public PetOwnerMapperProfile()
        {
            CreateMap<PetOwner, PetOwnerResponse>().ReverseMap();
            CreateMap<PetOwner, CreatePetOwnerCommand>().ReverseMap();
        }
    }
}
