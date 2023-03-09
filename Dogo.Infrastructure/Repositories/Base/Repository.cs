using Dogo.Core.Repositories.Base;
using Dogo.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories.Base
{
    public class Repository<T> : IRepository<T> where T : class
    {
        protected readonly DatabaseContext petOwnerContext;

        public Repository(DatabaseContext petOwnerContext) => this.petOwnerContext = petOwnerContext;
        
        public async Task<T> AddAsync(T entity)
        {
            await petOwnerContext.Set<T>().AddAsync(entity);
            await petOwnerContext.SaveChangesAsync();

            return entity;
        }

        public async Task DeleteAsync(T entity)
        {
            petOwnerContext.Set<T>().Remove(entity);
            await petOwnerContext.SaveChangesAsync();
        }

        public async Task<T> GetByIdAsync(Guid id) => await petOwnerContext.Set<T>().FindAsync(id);

        public async Task<IReadOnlyList<T>> GetAllAsync() => await petOwnerContext.Set<T>().ToListAsync();

        public async Task UpdateAsync(T entity)
        {
            petOwnerContext.Update(entity);
            await petOwnerContext.SaveChangesAsync();
        }

        public async Task SaveChanges() => await petOwnerContext.SaveChangesAsync();
    }
}
