using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Enitities;
using Dogo.Core.Repositories.Base;
using MediatR;

namespace Dogo.Application.Handlers
{
    public class CreatePetOwnerCommandHandler : IRequestHandler<CreatePetOwnerCommand, PetOwnerResponse>
    {

        private readonly IRepository<PetOwner> repository;

        public CreatePetOwnerCommandHandler(IRepository<PetOwner> repository) => this.repository = repository;

        public async Task<PetOwnerResponse> Handle(CreatePetOwnerCommand request, CancellationToken cancellationToken)
        {
            var petOwnerEntity = PetOwnerMapper.Mapper.Map<PetOwner>(request);
            if (petOwnerEntity == null)
            {
                throw new ApplicationException("Issue with the mapper");
            }

            var newPetOwner = await repository.AddAsync(petOwnerEntity);
            return PetOwnerMapper.Mapper.Map<PetOwnerResponse>(newPetOwner);
        }
    }
}
