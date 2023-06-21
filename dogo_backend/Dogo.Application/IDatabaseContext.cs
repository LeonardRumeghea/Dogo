using Dogo.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Dogo.Application
{
    public interface IDatabaseContext
    {
        public DbSet<User> User { get; }
        public DbSet<Pet> Pets { get; }
        public DbSet<Appointment> Appointments { get; }
        public DbSet<Address> Addresses { get; }
        public DbSet<UserPreferences> UserPreferences { get; }
        public DbSet<Position> Positions { get; }

        public void Save();
    }
}