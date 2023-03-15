using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAppointmentByIdQuery : IRequest<ResultOfEntity<AppointmentResponse>>
    {
        public Guid Id { get; set; }
    }
}
