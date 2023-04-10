using Dogo.Application.Commands.PetOwner;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Handlers.PetOwner
{
    public class DeletePetOwnerCommandHandler : IRequestHandler<DeletePetOwnerCommand, HttpStatusCode>
    {
        private readonly IUnitOfWork unitOfWork;

        public DeletePetOwnerCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<HttpStatusCode> Handle(DeletePetOwnerCommand request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.Id);

            if (petOwner == null)
            {
                return HttpStatusCode.NotFound;
            }

            petOwner.Pets.ForEach(pet => unitOfWork.PetRepository.DeleteAsync(pet));

            await unitOfWork.PetOwnerRepository.DeleteAsync(petOwner);

            return HttpStatusCode.NoContent;
        }
    }
}
