using Dogo.Application;
using Dogo.Core.Enitities;
using Dogo.Core.Repositories.Base;
using Dogo.Infrastructure.Repositories;

#nullable disable
namespace Dogo.Infrastructure.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext context;

        public UnitOfWork(DatabaseContext context) => this.context = context;

        public IRepository<Pet> petRepository;
        public IRepository<Pet> PetRepository
        {
            get
            {
                petRepository ??= new PetRepository(context);
                return petRepository;
            }
        }

        public IRepository<PetOwner> petOwnerRepository;
        public IRepository<PetOwner> PetOwnerRepository
        {
            get
            {
                petOwnerRepository ??= new PetOwnerRepository(context);
                return petOwnerRepository;
            }
        }

        public IRepository<Appointment> appointmentRepository;
        public IRepository<Appointment> AppointmentRepository
        {
            get
            {
                appointmentRepository ??= new AppointmentRepository(context);
                return appointmentRepository;
            }
        }

        public IRepository<Walker> walkerRepository;
        public IRepository<Walker> WalkerRepository
        {
            get
            {
                walkerRepository ??= new WalkerRepository(context);
                return walkerRepository;
            }
        }

        public IRepository<Review> reviewRepository;
        public IRepository<Review> ReviewRepository
        {
            get
            {
                reviewRepository ??= new ReviewRepository(context);
                return reviewRepository;
            }
        }

        public async Task SaveChanges() => await context.SaveChangesAsync();
    }
}
