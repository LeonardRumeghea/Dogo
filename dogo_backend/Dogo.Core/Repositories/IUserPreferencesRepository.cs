using Dogo.Core.Entities;
using Dogo.Core.Repositories.Base;

namespace Dogo.Core.Repositories
{
    public interface IUserPreferencesRepository : IRepository<UserPreferences> 
    {
        Task<UserPreferences> getByUserId(Guid id);
    }
}
