using Dogo.Core.Enitities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;
using Microsoft.EntityFrameworkCore;

namespace Dogo.Infrastructure.Repositories
{
    public class PetOwnerRepository : Repository<PetOwner>, IPetOwnerRepository
    {
        public PetOwnerRepository(DatabaseContext context) : base(context) { }

        public async Task<IReadOnlyCollection<PetOwner>> GetPetOwnersByLastName(string lastName)
        {
            return await context.PetOwners.Where(x => x.LastName == lastName).ToListAsync();
        }
    }
}
