using Dogo.Core.Entities;
using Dogo.Core.Repositories.Base;

namespace Dogo.Core.Repositories
{
    public interface IPositionRepository : IRepository<Position> 
     {
        Task<Position> getByUserId(Guid id);
    }
}
