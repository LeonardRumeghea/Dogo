using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.UserPreferences
{
    public class GetUserPreferencesQuery : IRequest<ResultOfEntity<UserPreferencesResponse>>
    {
        public Guid Id { get; set; }
    }
}
