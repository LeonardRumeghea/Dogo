#nullable disable
namespace Dogo.Core.Entities
{
    public class Review
    {
        public Guid Id { get; set; }
        public Guid WrittenBy { get; set; }
        public string Comment { get; set; }
        public int Rating { get; set; }
        public Guid AppointmentId { get; set; }
    }
}
