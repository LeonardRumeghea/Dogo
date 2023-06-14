using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.UserPreferences
{
    public class GetUserPreferencesQueryHandler : IRequestHandler<GetUserPreferencesQuery, ResultOfEntity<UserPreferencesResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetUserPreferencesQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<UserPreferencesResponse>> Handle(GetUserPreferencesQuery request, CancellationToken cancellationToken)
        {
            var userPreferences = await unitOfWork.UserPreferencesRepository.getByUserId(request.Id);
            if (userPreferences == null)
            {
                return ResultOfEntity<UserPreferencesResponse>.Failure(HttpStatusCode.NotFound, "User preferences not found");
            }

            return ResultOfEntity<UserPreferencesResponse>.Success(
                HttpStatusCode.OK,
                UserPreferencesMapper.Mapper.Map<UserPreferencesResponse>(userPreferences)
            );
        }
    }
}
