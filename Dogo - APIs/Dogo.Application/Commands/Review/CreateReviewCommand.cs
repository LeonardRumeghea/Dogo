using Dogo.Application.Response;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.Review
{
    public class CreateReviewCommand : IRequest<ReviewResponse>
    {
        public string Comment { get; set; }
        public int Rating { get; set; }
        public Guid AppointmentId { get; set; }
        public Guid WrittenBy { get; set; }
    }
}
