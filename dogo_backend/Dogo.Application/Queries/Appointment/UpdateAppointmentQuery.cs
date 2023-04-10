using Dogo.Application.Commands.Appointment;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.Appointment
{
    public class UpdateAppointmentQuery : IRequest<Result>
    {
        public Guid Id { get; set; }
        public UpdateAppointmentCommand Appointment { get; set; }
    }
}
