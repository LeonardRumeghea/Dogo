using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAllAppointmentsQuery : IRequest<ResultOfEntity<List<AppointmentResponse>>> { }
}
