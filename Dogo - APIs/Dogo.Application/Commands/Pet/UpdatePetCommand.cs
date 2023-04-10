using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.Pet
{
    public class UpdatePetCommand : IRequest<Result>
    {
        public string Name { get; set; }
        public string Description { get; set; }
        //public string ImageUrl { get; set; } TODO
        public string Specie { get; set; }
        public string Breed { get; set; }
        public string DateOfBirth { get; set; }
        public string Gender { get; set; }
    }
}
