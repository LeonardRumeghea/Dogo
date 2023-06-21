using AutoMapper;
using Dogo.Application.Commands.Position;
using Dogo.Application.Response;
using Dogo.Core.Entities;

namespace Dogo.Application.Mappers
{
    public class PositionMapperProfile : Profile
    {
        public PositionMapperProfile()
        {
            CreateMap<CreatePositionCommand, Position>();
            CreateMap<Position, PositionResponse>();
        }
    }
}
