using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class RemovePetFromOwnerHandler : IRequestHandler<RemovePetFromOwner, Result>
    {
        private readonly IUnitOfWork unitOfWork;

        public RemovePetFromOwnerHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<Result> Handle(RemovePetFromOwner request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.PetOwnerId);
            if (petOwner == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Pet owner not found");
            }

            var pet = await unitOfWork.PetRepository.GetByIdAsync(request.PetId);
            if (pet == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Pet not found");
            }

            petOwner.RemovePet(pet);
            await unitOfWork.PetOwnerRepository.UpdateAsync(petOwner);
            await unitOfWork.PetRepository.DeleteAsync(pet);

            return Result.Success(HttpStatusCode.NoContent);
        }
    }
}
