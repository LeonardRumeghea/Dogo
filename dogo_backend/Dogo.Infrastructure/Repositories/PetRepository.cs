using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;

namespace Dogo.Infrastructure.Repositories
{
    public class PetRepository : Repository<Pet>, IPetRepository
    {
        public PetRepository(DatabaseContext petOwnerContext) : base(petOwnerContext) { }
    }
}
