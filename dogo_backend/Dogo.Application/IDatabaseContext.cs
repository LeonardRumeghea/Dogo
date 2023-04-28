using Dogo.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Dogo.Application
{
    public interface IDatabaseContext
    {
        public DbSet<PetOwner> PetOwners { get; }
        public DbSet<Walker> Walkers { get; }
        public DbSet<Pet> Pets { get; }
        public DbSet<Appointment> Appointments { get; }
        public DbSet<Address> Addresses { get; }
        public DbSet<Review> Reviews { get; }

        public void Save();
    }
}