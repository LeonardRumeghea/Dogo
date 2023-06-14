using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Core.Repositories.Base;

namespace Dogo.Application
{
    public interface IUnitOfWork
    {
        IRepository<Pet> PetRepository { get; }
        IUserRepository UsersRepository { get; }
        IRepository<Appointment> AppointmentRepository { get; }
        IRepository<Address> AddressRepository { get; }
        IUserPreferencesRepository UserPreferencesRepository { get; }

        Task SaveChanges();
    }
}
