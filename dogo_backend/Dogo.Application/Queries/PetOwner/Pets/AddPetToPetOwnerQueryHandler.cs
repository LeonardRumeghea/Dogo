using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class AddPetToPetOwnerQueryHandler : IRequestHandler<AddPetToPetOwnerQuery, ResultOfEntity<PetResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public AddPetToPetOwnerQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PetResponse>> Handle(AddPetToPetOwnerQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.PetOwnerId);

            if (petOwner == null)
            {
                return ResultOfEntity<PetResponse>.Failure(HttpStatusCode.NotFound, "Pet Owner not found");
            }

            var pet = PetMapper.Mapper.Map<Pet>(request.Pet);

            if (pet == null)
            {
                return ResultOfEntity<PetResponse>.Failure(HttpStatusCode.BadRequest, "Pet is null");
            }

            var result = petOwner.RegisterPet(pet);

            if (result.IsFailure || result.Entity == null)
            {
                return ResultOfEntity<PetResponse>.Failure(
                    HttpStatusCode.BadRequest,
                    result.Message != null ? result.Message : "Pet is null");
            }

            pet = result.Entity;


            await unitOfWork.PetOwnerRepository.UpdateAsync(petOwner);
            await unitOfWork.PetRepository.UpdateAsync(pet);

            return ResultOfEntity<PetResponse>.Success(HttpStatusCode.Created, PetMapper.Mapper.Map<PetResponse>(pet));
        }
    }
}
