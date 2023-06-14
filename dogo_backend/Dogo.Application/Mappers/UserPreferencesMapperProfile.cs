using AutoMapper;
using Dogo.Application.Commands.User.Preferences;
using Dogo.Application.Response;
using Dogo.Core.Entities;

namespace Dogo.Application.Mappers
{
    public class UserPreferencesMapperProfile : Profile
    {
        public UserPreferencesMapperProfile()
        {
            CreateMap<UserPreferences, CreateUserPreferencesCommand>().ReverseMap();
            CreateMap<UserPreferences, UserPreferencesResponse>().ReverseMap();
        }
    }
}
