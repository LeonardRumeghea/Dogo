using Dogo.Core.Enums.Species;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class UpdatePetQueryHandler : IRequestHandler<UpdatePetQuery, Result>
    {
        private readonly IUnitOfWork unitOfWork;

        public UpdatePetQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<Result> Handle(UpdatePetQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.UsersRepository.GetByIdAsync(request.PetOwnerId);

            if (petOwner == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Pet owner not found");
            }

            var pet = await unitOfWork.PetRepository.GetByIdAsync(request.PetId);
            
            if (pet == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Pet not found");
            }

            pet.Name = request.Pet.Name;
            pet.Specie = Enum.Parse<Specie>(request.Pet.Specie);
            pet.Breed = request.Pet.Breed;
            pet.DateOfBirth = DateTime.Parse(request.Pet.DateOfBirth);
            pet.Description = request.Pet.Description;

            await unitOfWork.PetRepository.UpdateAsync(pet);

            return Result.Success(HttpStatusCode.NoContent);
        }
    }
}
