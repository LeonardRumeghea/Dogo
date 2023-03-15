using Dogo.Application.Commands.Pet;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class UpdatePetQuery : IRequest<Result>
    {
        public Guid PetOwnerId { get; set; }
        public Guid PetId { get; set; }
        public UpdatePetCommand Pet { get; set; }
    }
}
