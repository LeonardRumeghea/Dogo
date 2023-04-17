using Dogo.Core.Enitities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories
{
    public class PersonRepository : Repository<Person>, IPersonRepository
    {
        public PersonRepository(DatabaseContext context) : base(context) { }

        public override async Task<Person> GetByIdAsync(Guid id)
        {
            return await context.Set<Person>()
                .Include(x => x.Address)
                .SingleOrDefaultAsync(x => x.Id == id);
        }

        public override async Task<IReadOnlyList<Person>> GetAllAsync()
        {
            return await context.Set<Person>()
                .Include(x => x.Address)
                .ToListAsync();
        }
    }
}
