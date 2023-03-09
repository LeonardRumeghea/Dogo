using Dogo.Core.Enitities;
using Dogo.Core.Repositories.Base;

namespace Dogo.Application
{
    public interface IUnitOfWork
    {
        IRepository<Pet> PetRepository { get; }
        IRepository<PetOwner> PetOwnerRepository { get; }
        IRepository<Appointment> AppointmentRepository { get; }
        IRepository<Walker> WalkerRepository { get; }
        IRepository<Review> ReviewRepository { get; }

        Task SaveChanges();
    }
}
