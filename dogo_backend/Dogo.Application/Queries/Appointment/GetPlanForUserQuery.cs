using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.Appointment
{
    public class GetPlanForUserQuery : IRequest<ResultOfEntity<List<AppointmentResponse>>>
    {
        public Guid UserId { get; set; }
        public string TravelMode { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int NumberOfAppointments { get; set; }
    }
}
