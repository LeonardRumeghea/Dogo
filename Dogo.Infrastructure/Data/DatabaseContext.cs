using Dogo.Application;
using Dogo.Core.Enitities;
using Microsoft.EntityFrameworkCore;

/*
 *  - Add-Migration InitialCreate
 *  - Update-Database
 *  
 *  - Remove-Migration InitialCreate
 *  - Drop-Database
 */

namespace Dogo.Infrastructure.Data
{
    public class DatabaseContext : DbContext, IDatabaseContext
    {
        public DatabaseContext(DbContextOptions options) : base(options)
        {
            Database.EnsureCreated();
        }

        public DbSet<PetOwner> PetOwners => Set<PetOwner>();
        public DbSet<Walker> Walkers => Set<Walker>();
        public DbSet<Pet> Pets => Set<Pet>();
        public DbSet<Appointment> Appointments => Set<Appointment>();
        public DbSet<Address> Addresses => Set<Address>();
        public DbSet<Review> Reviews => Set<Review>();

        public void Save() => SaveChanges();
    }
}
