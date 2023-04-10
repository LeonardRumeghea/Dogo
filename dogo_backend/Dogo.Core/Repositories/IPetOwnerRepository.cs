﻿using Dogo.Core.Enitities;
using Dogo.Core.Repositories.Base;

namespace Dogo.Core.Repositories
{
    public interface IPetOwnerRepository : IRepository<PetOwner>
    {
        Task<IReadOnlyCollection<PetOwner>> GetPetOwnersByLastName(string lastName);
    }
}