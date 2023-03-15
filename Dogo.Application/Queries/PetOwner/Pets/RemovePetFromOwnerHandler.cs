using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class RemovePetFromOwnerHandler : IRequestHandler<RemovePetFromOwner, HttpStatusCode>
    {
        private readonly IUnitOfWork unitOfWork;

        public RemovePetFromOwnerHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<HttpStatusCode> Handle(RemovePetFromOwner request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.PetOwnerId);
            if (petOwner == null)
            {
                return HttpStatusCode.NotFound;
            }

            var pet = await unitOfWork.PetRepository.GetByIdAsync(request.PetId);
            if (pet == null)
            {
                return HttpStatusCode.NotFound;
            }

            petOwner.RemovePet(pet);
            await unitOfWork.PetOwnerRepository.UpdateAsync(petOwner);
            await unitOfWork.PetRepository.DeleteAsync(pet);

            return HttpStatusCode.NoContent;
        }
    }
}
