using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories
{
    public class WalkerRepository : Repository<Walker>, IWalkerRepository
    {
        public WalkerRepository(DatabaseContext context) : base(context) { }

        public override async Task<Walker> GetByIdAsync(Guid id) 
            => await context.Set<Walker>()
                .Include(x => x.Address)
                .SingleOrDefaultAsync(x => x.Id == id);

        public override async Task<IReadOnlyList<Walker>> GetAllAsync() 
            => await context.Set<Walker>()
                .Include(x => x.Address)
                .ToListAsync();
    }
}
