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

        private IRepository<Pet> petRepository;
        public IRepository<Pet> PetRepository
        {
            get
            {
                petRepository ??= new PetRepository(context);
                return petRepository;
            }
        }

        private IRepository<PetOwner> petOwnerRepository;
        public IRepository<PetOwner> PetOwnerRepository
        {
            get
            {
                petOwnerRepository ??= new PetOwnerRepository(context);
                return petOwnerRepository;
            }
        }

        private IRepository<Appointment> appointmentRepository;
        public IRepository<Appointment> AppointmentRepository
        {
            get
            {
                appointmentRepository ??= new AppointmentRepository(context);
                return appointmentRepository;
            }
        }

        private IRepository<Walker> walkerRepository;
        public IRepository<Walker> WalkerRepository
        {
            get
            {
                walkerRepository ??= new WalkerRepository(context);
                return walkerRepository;
            }
        }

        private IRepository<Review> reviewRepository;
        public IRepository<Review> ReviewRepository
        {
            get
            {
                reviewRepository ??= new ReviewRepository(context);
                return reviewRepository;
            }
        }

        private IRepository<Address> addressRepository;
        public IRepository<Address> AddressRepository
        {
            get
            {
                addressRepository ??= new AddressRepository(context);
                return addressRepository;
            }
        }

        public async Task SaveChanges() => await context.SaveChangesAsync();
    }
}
