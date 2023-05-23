using Dogo.Core.Entities;

#nullable disable
namespace Dogo.Application.Response
{
    public class AppointmentResponse
    {
        public Guid Id { get; set; }
        public DateTime DateWhen { get; set; }
        public DateTime DateUntil { get; set; }
        public string Notes { get; set; }
        public Guid PetId { get; set; }
        public AddressResponse Address { get; set; }
        public int Duration { get; set; }
        public AppointmentType Type { get; set; }
        public Guid WalkerId { get; set; } // will be assigned by the system 
        public bool IsAssigned { get; set; }
        public AppointmentStatus Status { get; set; }
    }
}
