namespace Dogo.Core.Repositories.Base
{
    public interface IRepository<T> where T: class
    {
        public Task<T> GetByIdAsync(Guid id);
        public Task<IReadOnlyList<T>> GetAllAsync();
        public Task<T> AddAsync(T entity);
        public Task UpdateAsync(T entity);
        public Task DeleteAsync(T entity);
    }
}
