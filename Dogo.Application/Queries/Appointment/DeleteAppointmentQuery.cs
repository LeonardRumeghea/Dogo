using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class DeleteAppointmentQuery : IRequest<Result>
    {
        public Guid Id { get; set; }
    }
}
