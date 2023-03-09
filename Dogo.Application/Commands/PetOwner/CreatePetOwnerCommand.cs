using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Commands.PetOwner
{
    public class CreatePetOwnerCommand : IRequest<PetOwnerResponse>
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public AdressResponse? Address { get; set; }
    }
}
