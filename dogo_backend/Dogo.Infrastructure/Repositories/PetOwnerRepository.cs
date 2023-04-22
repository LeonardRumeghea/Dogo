using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

#nullable disable
namespace Dogo.Infrastructure.Repositories
{
    public class PetOwnerRepository : Repository<PetOwner>, IPetOwnerRepository
    {
        public PetOwnerRepository(DatabaseContext context) : base(context) { }

        public async Task<IReadOnlyCollection<PetOwner>> GetPetOwnersByLastName(string lastName)
        {
            return await context.PetOwners.Where(x => x.LastName == lastName).ToListAsync();
        }

        public override async Task<PetOwner> GetByIdAsync(Guid id)
        {
            return await context.Set<PetOwner>()
                .Include(x => x.Pets)
                .Include(x => x.Address)
                .SingleOrDefaultAsync(x => x.Id == id);
        }

        public override async Task<IReadOnlyList<PetOwner>> GetAllAsync()
        {
            return await context.Set<PetOwner>()
                .Include(x => x.Pets)
                .Include(x => x.Address)
                .ToListAsync();
        }

        public async Task<PetOwner> GetByEmail(string email) 
            => await context.PetOwners
            .Include(x => x.Pets)
            .Include(x => x.Address)
            .SingleOrDefaultAsync(x => x.Email == email);
    }
}
