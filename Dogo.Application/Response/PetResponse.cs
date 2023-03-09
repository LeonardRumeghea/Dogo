using Dogo.Core.Enums.Species;
using Dogo.Core.Enums;

namespace Dogo.Application.Response
{
    public class PetResponse
    {
        public Guid Id { get; set; }
        public Guid PetOwnerId { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public Specie Specie { get; set; }
        public string? Breed { get; set; }
        public DateTime DateOfBirth { get; set; }
        public PetGender Gender { get; set; }
    }
}
