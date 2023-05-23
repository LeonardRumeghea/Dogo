using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories
{
    public class UserPreferencesRepository : Repository<UserPreferences>, IUserPreferencesRepository
    {
        public UserPreferencesRepository(DatabaseContext context) : base(context) { }

        public Task<UserPreferences> getByUserId(Guid id) => context.UserPreferences.FirstOrDefaultAsync(x => x.UserId == id);
    }
}
