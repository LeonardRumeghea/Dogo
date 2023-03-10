using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetPetOwnerByIdQueryHandler : IRequestHandler<GetPetOwnerByIdQuery, PetOwnerResponse>
    {
        private readonly IPetOwnerRepository _petOwnerRepository;

        public GetPetOwnerByIdQueryHandler(IPetOwnerRepository petOwnerRepository) 
            => _petOwnerRepository = petOwnerRepository;

        public async Task<PetOwnerResponse> Handle(GetPetOwnerByIdQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await _petOwnerRepository.GetByIdAsync(request.Id);
            return PetOwnerMapper.Mapper.Map<PetOwnerResponse>(petOwner);
        }
    }
}
