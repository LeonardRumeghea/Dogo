namespace Dogo.Application.Response
{
    public class AppointmentResponse
    {
        public Guid Id { get; set; }
        public DateTime Date { get; set; }
        public string? Notes { get; set; }
        public Guid PetId { get; set; }
        public Guid WalkerId { get; set; }
    }
}
