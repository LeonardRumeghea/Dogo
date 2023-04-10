using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.Appointment
{
    public class CreateAppointmentCommand : IRequest<ResultOfEntity<AppointmentResponse>>
    {
        public string Date { get; set; }
        public string Notes { get; set; }
        public Guid PetId { get; set; }
        public Guid WalkerId { get; set; }
    }
}
