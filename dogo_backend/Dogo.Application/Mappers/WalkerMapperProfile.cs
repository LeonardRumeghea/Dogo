using AutoMapper;
using Dogo.Application.Commands.Walker;
using Dogo.Application.Response;
using Dogo.Core.Enitities;

namespace Dogo.Application.Mappers
{
    public class WalkerMapperProfile : Profile
    {
        public WalkerMapperProfile()
        {
            CreateMap<Walker, WalkerResponse>().ReverseMap();
            CreateMap<Walker, CreateWalkerCommand>().ReverseMap();
        }
    }
}
