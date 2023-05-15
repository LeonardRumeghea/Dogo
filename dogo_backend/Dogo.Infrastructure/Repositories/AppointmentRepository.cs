using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories
{
    public class AppointmentRepository : Repository<Appointment>, IAppointmentRepository
    {
        public AppointmentRepository(DatabaseContext context) : base(context) { }

        public override async Task<Appointment> GetByIdAsync(Guid id)
        {
            return await context.Set<Appointment>()
                .Include(x => x.Address)
                .SingleOrDefaultAsync(x => x.Id == id);
        }

        public override async Task<IReadOnlyList<Appointment>> GetAllAsync()
        {
            return await context.Set<Appointment>()
                .Include(x => x.Address)
                .ToListAsync();
        }
    }
}
