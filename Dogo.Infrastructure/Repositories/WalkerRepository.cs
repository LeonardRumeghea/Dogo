using Dogo.Core.Enitities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;

namespace Dogo.Infrastructure.Repositories
{
    public class WalkerRepository : Repository<Walker>, IWalkerRepository
    {
        public WalkerRepository(DatabaseContext context) : base(context) { }
    }
}
