using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAppointmentsOfOwnerQuery : IRequest<ResultOfEntity<List<AppointmentResponse>>>
    {
        public Guid OwnerId { get; set; }
    }
}
