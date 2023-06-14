using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class InProgressAppointmentQuery : IRequest<Result>
    {
        public Guid UserId { get; set; }
        public Guid AppointmentId { get; set; }
    }
}
