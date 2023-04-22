#nullable disable
namespace Dogo.Core.Entities
{
    public class Appointment
    {
        public Guid Id { get; set; }
        public DateTime DateWhen { get; set; }
        public DateTime DateUntil { get; set; }
        public string Notes { get; set; }
        public Guid PetId { get; set; }
        public string Location { get; set; }
        public int Duration { get; set; }
        public AppointmentType Type { get; set; }

        public Guid WalkerId { get; set; } // will be assigned by the system 
        public bool IsAssigned { get; set; }
        public AppointmentStatus Status { get; set; }
    }

    public enum AppointmentStatus
    {
        Pending = 0,
        Assigned = 1,
        Completed = 2,
        Cancelled = 3,
        Rejected = 4
    }

    public enum AppointmentType
    {
        Walk = 0,
        Salon = 1,
        Sitting = 2,
        Vet = 3,
        Shopping = 4
    }
}
