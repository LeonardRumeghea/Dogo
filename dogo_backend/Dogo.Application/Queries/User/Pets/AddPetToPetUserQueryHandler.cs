using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class AddPetToPetUserQueryHandler : IRequestHandler<AddPetToPetUserQuery, ResultOfEntity<PetResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public AddPetToPetUserQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PetResponse>> Handle(AddPetToPetUserQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.UsersRepository.GetByIdAsync(request.PetOwnerId);

            if (petOwner == null)
            {
                return ResultOfEntity<PetResponse>.Failure(HttpStatusCode.NotFound, "Pet Owner not found");
            }

            var pet = PetMapper.Mapper.Map<Core.Entities.Pet>(request.Pet);

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


            await unitOfWork.UsersRepository.UpdateAsync(petOwner);
            await unitOfWork.PetRepository.UpdateAsync(pet);

            return ResultOfEntity<PetResponse>.Success(HttpStatusCode.Created, PetMapper.Mapper.Map<PetResponse>(pet));
        }
    }
}
