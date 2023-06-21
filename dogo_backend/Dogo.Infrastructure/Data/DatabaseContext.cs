using Dogo.Application;
using Dogo.Core.Entities;
using Microsoft.EntityFrameworkCore;

/*
 *  - Add-Migration InitialCreate
 *  - Update-Database
 *  
 *  - Remove-Migration
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

        public DbSet<User> User => Set<User>();
        public DbSet<Pet> Pets => Set<Pet>();
        public DbSet<Appointment> Appointments => Set<Appointment>();
        public DbSet<Address> Addresses => Set<Address>();
        public DbSet<UserPreferences> UserPreferences => Set<UserPreferences>();
        public DbSet<Position> Positions => Set<Position>();

        public void Save() => SaveChanges();
    }
}
