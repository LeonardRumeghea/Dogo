using Dogo.Application.Response;
using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.Appointment
{
    public class CreateAppointmentCommand : IRequest<ResultOfEntity<AppointmentResponse>>
    {
        public string DateWhen { get; set; }
        public string DateUntil { get; set; }
        public string Notes { get; set; }
        public Guid PetId { get; set; }
        public string Location { get; set; }
        public string Duration { get; set; }
        public string Type { get; set; }
    }
}
