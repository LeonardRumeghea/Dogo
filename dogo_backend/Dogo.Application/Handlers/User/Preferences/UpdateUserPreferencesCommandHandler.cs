using Dogo.Application.Commands.User.Preferences;
using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Handlers.User.Preferences
{
    public class UpdateUserPreferencesCommandHandler : IRequestHandler<UpdateUserPreferencesCommand, Result>
    {
        private readonly IUnitOfWork _unitOfWork;

        public UpdateUserPreferencesCommandHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<Result> Handle(UpdateUserPreferencesCommand request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
                return Result.Failure(HttpStatusCode.NotFound, "User not found");

            var userPreferences = await _unitOfWork.UserPreferencesRepository.GetByIdAsync(request.Id);
            if (userPreferences == null)
                return Result.Failure(HttpStatusCode.NoContent, "User preferences are not set");

            userPreferences.DogPreference = Enum.Parse<PreferenceDegree>(request.DogPreference);
            userPreferences.CatPreference = Enum.Parse<PreferenceDegree>(request.CatPreference);
            userPreferences.RabbitPreference = Enum.Parse<PreferenceDegree>(request.RabbitPreference);
            userPreferences.BirdPreference = Enum.Parse<PreferenceDegree>(request.BirdPreference);
            userPreferences.FishPreference = Enum.Parse<PreferenceDegree>(request.FishPreference);
            userPreferences.FerretPreference = Enum.Parse<PreferenceDegree>(request.FerretPreference);
            userPreferences.GuineaPigPreference = Enum.Parse<PreferenceDegree>(request.GuineaPigPreference);

            userPreferences.WalkPreference = Enum.Parse<PreferenceDegree>(request.WalkPreference);
            userPreferences.VetPreference = Enum.Parse<PreferenceDegree>(request.VetPreference);
            userPreferences.SalonPreference = Enum.Parse<PreferenceDegree>(request.SalonPreference);
            userPreferences.SitPreference = Enum.Parse<PreferenceDegree>(request.SitPreference);
            userPreferences.ShoppingPreference = Enum.Parse<PreferenceDegree>(request.ShoppingPreference);

            await _unitOfWork.UserPreferencesRepository.UpdateAsync(userPreferences);
            await _unitOfWork.SaveChanges();

            return Result.Success();
        }
    }
}
