#nullable disable
namespace Dogo.Core.Enitities
{
    public class Appointment
    {
        public Guid Id { get; set; }
        public DateTime Date { get; set; }
        public string Notes { get; set; }
        public Guid PetId { get; set; }
        public Guid WalkerId { get; set; }
    }
}
