using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class RemovePetFromOwnerHandler : IRequestHandler<RemovePetFromOwner, HttpStatusCodeResponse>
    {
        private readonly IUnitOfWork unitOfWork;

        public RemovePetFromOwnerHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<HttpStatusCodeResponse> Handle(RemovePetFromOwner request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.PetOwnerId);
            if (petOwner == null)
            {
                return HttpStatusCodeResponse.NotFound;
            }

            var pet = await unitOfWork.PetRepository.GetByIdAsync(request.PetId);
            if (pet == null)
            {
                return HttpStatusCodeResponse.NotFound;
            }

            petOwner.RemovePet(pet);
            await unitOfWork.PetOwnerRepository.UpdateAsync(petOwner);
            await unitOfWork.PetRepository.DeleteAsync(pet);

            return HttpStatusCodeResponse.NoContent;
        }
    }
}
