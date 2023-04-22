using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Handlers.PetOwner
{
    public class CreatePetOwnerCommandHandler : IRequestHandler<CreatePetOwnerCommand, ResultOfEntity<PetOwnerResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public CreatePetOwnerCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PetOwnerResponse>> Handle(CreatePetOwnerCommand request, CancellationToken cancellationToken)
        {

            var petOwner = await unitOfWork.PetOwnerRepository.GetByEmail(request.Email);
            if (petOwner != null)
            {
                return ResultOfEntity<PetOwnerResponse>.Failure(HttpStatusCode.Conflict, "Email already exists");
            }

            var petOwnerEntity = PetOwnerMapper.Mapper.Map<Core.Entities.PetOwner>(request);
            if (petOwnerEntity == null)
            {
                return ResultOfEntity<PetOwnerResponse>.Failure(HttpStatusCode.BadRequest, "Invalid data");
            }

            petOwnerEntity.Address = await unitOfWork.AddressRepository.AddAsync(petOwnerEntity.Address);

            var newPetOwner = await unitOfWork.PetOwnerRepository.AddAsync(petOwnerEntity);

            return ResultOfEntity<PetOwnerResponse>.Success(
                HttpStatusCode.Created,
                PetOwnerMapper.Mapper.Map<PetOwnerResponse>(newPetOwner)
            );
        }
    }
}
