namespace Dogo.Application.Response
{
    public class ReviewResponse
    {
        public Guid Id { get; set; }
        public string? Comment { get; set; }
        public int Rating { get; set; }
        public Guid AppointmentId { get; set; }
    }
}
