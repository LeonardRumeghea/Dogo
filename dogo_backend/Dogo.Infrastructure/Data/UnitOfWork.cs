using Dogo.Application;
using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Core.Repositories.Base;
using Dogo.Infrastructure.Repositories;

#nullable disable
namespace Dogo.Infrastructure.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext _context;

        private IUserRepository userRepository;
        private IRepository<Pet> petRepository;
        private IRepository<Appointment> appointmentRepository;
        private IRepository<Address> addressRepository;
        private IUserPreferencesRepository userPreferencesRepository;

        public UnitOfWork(DatabaseContext context) => _context = context;

        public IRepository<Pet> PetRepository
        {
            get
            {
                petRepository ??= new PetRepository(_context);
                return petRepository;
            }
        }

        public IRepository<Appointment> AppointmentRepository
        {
            get
            {
                appointmentRepository ??= new AppointmentRepository(_context);
                return appointmentRepository;
            }
        }

        public IRepository<Address> AddressRepository
        {
            get
            {
                addressRepository ??= new AddressRepository(_context);
                return addressRepository;
            }
        }

        public IUserRepository UsersRepository
        {
            get
            {
                userRepository ??= new UserRepository(_context);
                return userRepository;
            }
        }

        public IUserPreferencesRepository UserPreferencesRepository
        { 
            get
            {
                userPreferencesRepository ??= new UserPreferencesRepository(_context);
                return userPreferencesRepository;
            }
        }

        public async Task SaveChanges() => await _context.SaveChangesAsync();
    }
}
