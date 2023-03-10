using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Commands.Appointment
{
    public class CreateAppointmentCommand : IRequest<AppointmentResponse>
    {
        public string? Date { get; set; }
        public string? Notes { get; set; }
        public Guid PetId { get; set; }
        public Guid WalkerId { get; set; }
    }
}
