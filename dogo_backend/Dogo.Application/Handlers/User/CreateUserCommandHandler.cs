using Dogo.Application.Commands.User;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using Dogo.Core.Entities;
using MediatR;

#nullable disable
namespace Dogo.Application.Handlers.User
{
    public class CreateUserCommandHandler : IRequestHandler<CreateUserCommand, ResultOfEntity<UserResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public CreateUserCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<UserResponse>> Handle(CreateUserCommand request, CancellationToken cancellationToken)
        {

            var user = await unitOfWork.UsersRepository.GetByEmail(request.Email);
            if (user != null)
            {
                return ResultOfEntity<UserResponse>.Failure(HttpStatusCode.Conflict, "Email already exists");
            }

            var userEntity = UserMapper.Mapper.Map<Core.Entities.User>(request);
            if (userEntity == null)
            {
                return ResultOfEntity<UserResponse>.Failure(HttpStatusCode.BadRequest, "Invalid data");
            }

            userEntity.Address = await unitOfWork.AddressRepository.AddAsync(userEntity.Address);

            var newUser = await unitOfWork.UsersRepository.AddAsync(userEntity);

            var userPreferences = new UserPreferences();
            userPreferences.UserId = newUser.Id;

            await unitOfWork.UserPreferencesRepository.AddAsync(userPreferences);

            return ResultOfEntity<UserResponse>.Success(
                HttpStatusCode.Created,
                UserMapper.Mapper.Map<UserResponse>(newUser)
            );
        }
    }
}
