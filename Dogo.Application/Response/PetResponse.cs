namespace Dogo.Application.Response
{
    public class PetResponse
    {
        public Guid Id { get; set; }
        public Guid OwnerId { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public string? Specie { get; set; }
        public string? Breed { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string? Gender { get; set; }
    }
}
