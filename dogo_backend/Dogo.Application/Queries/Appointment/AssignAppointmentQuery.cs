using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class AssignAppointmentQuery : IRequest<Result>
    {
        public Guid AppointmentId { get; set; }
        public Guid UserId { get; set; }
    }
}
