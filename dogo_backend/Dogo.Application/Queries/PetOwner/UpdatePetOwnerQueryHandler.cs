using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.PetOwner
{
    public class UpdatePetOwnerQueryHandler : IRequestHandler<UpdatePetOwnerQuery, ResultOfEntity<PetOwnerResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public UpdatePetOwnerQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PetOwnerResponse>> Handle(UpdatePetOwnerQuery request, CancellationToken cancellationToken)
        {
            var petOwnerEntity = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.Id);
            if (petOwnerEntity == null)
            {
                return ResultOfEntity<PetOwnerResponse>.Failure(HttpStatusCode.NotFound, "Pet owner not found");
            }

            petOwnerEntity.FirstName = request.PetOwner.FirstName;
            petOwnerEntity.LastName = request.PetOwner.LastName;
            petOwnerEntity.Email = request.PetOwner.Email;
            petOwnerEntity.PhoneNumber = request.PetOwner.PhoneNumber;
            petOwnerEntity.Address = AddressMapper.Mapper.Map<Address>(request.PetOwner.Address);

            await unitOfWork.PetOwnerRepository.UpdateAsync(petOwnerEntity);

            return ResultOfEntity<PetOwnerResponse>.Success(
                HttpStatusCode.NoContent,
                PetOwnerMapper.Mapper.Map<PetOwnerResponse>(petOwnerEntity)
            );
        }
    }
}
