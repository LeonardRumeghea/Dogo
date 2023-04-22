using AutoMapper;
using Dogo.Application.Commands.Appointment;
using Dogo.Application.Response;
using Dogo.Core.Entities;

namespace Dogo.Application.Mappers
{
    public class AppointmentMapperProfile : Profile
    {
        public AppointmentMapperProfile()
        {
            CreateMap<Appointment, AppointmentResponse>().ReverseMap();
            CreateMap<Appointment, CreateAppointmentCommand>().ReverseMap();
        }
    }
}
