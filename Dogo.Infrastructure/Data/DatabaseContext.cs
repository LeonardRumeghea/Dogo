using Dogo.Core.Enitities;
using Microsoft.EntityFrameworkCore;

namespace Dogo.Infrastructure.Data
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options) { }

        public DbSet<PetOwner> PetOwners { get; set; }
    }
}
