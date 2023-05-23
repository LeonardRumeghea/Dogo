using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Queries.User
{
    public class UpdateUserQueryHandler : IRequestHandler<UpdateUserQuery, ResultOfEntity<UserResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public UpdateUserQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<UserResponse>> Handle(UpdateUserQuery request, CancellationToken cancellationToken)
        {
            var petOwnerEntity = await unitOfWork.UsersRepository.GetByIdAsync(request.Id);
            if (petOwnerEntity == null)
            {
                return ResultOfEntity<UserResponse>.Failure(HttpStatusCode.NotFound, "Pet owner not found");
            }

            petOwnerEntity.FirstName = request.PetOwner.FirstName;
            petOwnerEntity.LastName = request.PetOwner.LastName;
            petOwnerEntity.Email = request.PetOwner.Email;
            petOwnerEntity.PhoneNumber = request.PetOwner.PhoneNumber;
            petOwnerEntity.Address = AddressMapper.Mapper.Map<Address>(request.PetOwner.Address);

            await unitOfWork.UsersRepository.UpdateAsync(petOwnerEntity);

            return ResultOfEntity<UserResponse>.Success(
                HttpStatusCode.NoContent,
                UserMapper.Mapper.Map<UserResponse>(petOwnerEntity)
            );
        }
    }
}
