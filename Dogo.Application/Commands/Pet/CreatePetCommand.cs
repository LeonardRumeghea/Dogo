using Dogo.Application.Response;
using Dogo.Core.Enums.Species;
using Dogo.Core.Enums;
using MediatR;

namespace Dogo.Application.Commands.Pet
{
    public class CreatePetCommand : IRequest<PetResponse>
    {
        public string? Name { get; set; }
        public string? Description { get; set; }
        public string? Specie { get; set; }
        public string? Breed { get; set; }
        public string? DateOfBirth { get; set; }
        public string? Gender { get; set; }
    }
}
