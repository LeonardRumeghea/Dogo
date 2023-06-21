using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories
{
    public class PositionRepository : Repository<Position>, IPositionRepository
    {
        public PositionRepository(DatabaseContext context) : base(context) { }

        public Task<Position> getByUserId(Guid id) => context.Positions.FirstOrDefaultAsync(x => x.UserId == id);
    }
}
