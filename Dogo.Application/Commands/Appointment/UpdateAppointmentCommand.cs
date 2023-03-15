#nullable disable
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Commands.Appointment
{
    public class UpdateAppointmentCommand : IRequest<Result>
    {
        public Guid PetId { get; set; }
        public Guid WalkerId { get; set; }
        public string Date { get; set; }
        public string Notes { get; set; }
    }
}
