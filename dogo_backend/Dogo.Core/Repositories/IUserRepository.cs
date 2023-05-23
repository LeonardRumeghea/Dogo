using Dogo.Core.Entities;
using Dogo.Core.Repositories.Base;

namespace Dogo.Core.Repositories
{
    public interface IUserRepository : IRepository<User>
    {
        Task<User> GetByEmail(string email);
    }
}
