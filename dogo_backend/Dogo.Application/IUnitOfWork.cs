using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Core.Repositories.Base;

namespace Dogo.Application
{
    public interface IUnitOfWork
    {
        IRepository<Pet> PetRepository { get; }
        IPetOwnerRepository PetOwnerRepository { get; }
        IRepository<Appointment> AppointmentRepository { get; }
        IRepository<Walker> WalkerRepository { get; }
        IRepository<Review> ReviewRepository { get; }
        IRepository<Address> AddressRepository { get; }

        Task SaveChanges();
    }
}
