using Dogo.Application.Commands.User.Preferences;
using Dogo.Application.Mappers;
using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Handlers.User.Preferences
{
    public class CreateUserPreferencesCommandHandler : IRequestHandler<CreateUserPreferencesCommand, Result>
    {
        private readonly IUnitOfWork _unitOfWork;

        public CreateUserPreferencesCommandHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<Result> Handle(CreateUserPreferencesCommand request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
                return Result.Failure(HttpStatusCode.NotFound, "User not found");

            var preferences = UserPreferencesMapper.Mapper.Map<UserPreferences>(request);

            await _unitOfWork.UserPreferencesRepository.AddAsync(preferences);
            await _unitOfWork.SaveChanges();

            return Result.Success();
        }
    }
}
