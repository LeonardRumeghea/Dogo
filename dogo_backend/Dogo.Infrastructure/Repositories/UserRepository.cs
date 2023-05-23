using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories
{
    public class UserRepository : Repository<User>, IUserRepository
    {
        public UserRepository(DatabaseContext context) : base(context) { }

        public override async Task<User> GetByIdAsync(Guid id)
        {
            return await context.Set<User>()
                .Include(x => x.Pets)
                .Include(x => x.Address)
                .SingleOrDefaultAsync(x => x.Id == id);
        }

        public override async Task<IReadOnlyList<User>> GetAllAsync()
        {
            return await context.Set<User>()
                .Include(x => x.Pets)
                .Include(x => x.Address)
                .ToListAsync();
        }

        public async Task<User> GetByEmail(string email) 
            => await context.User
            .Include(x => x.Pets)
            .Include(x => x.Address)
            .SingleOrDefaultAsync(x => x.Email == email);
    }
}
