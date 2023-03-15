using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.PetOwner
{
    public class UpdatePetOwnerQuery : IRequest<ResultOfEntity<PetOwnerResponse>>
    {
        public Guid Id { get; set; }
        public UpdatePetOwnerCommand PetOwner { get; set; }
}
}
