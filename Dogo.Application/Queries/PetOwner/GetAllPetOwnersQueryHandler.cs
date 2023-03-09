using AutoMapper;
using Dogo.Application.Response;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetAllPetOwnersQueryHandler : IRequestHandler<GetAllPetOwnersQuery, List<PetOwnerResponse>>
    {
        private readonly IMapper _mapper;
        private readonly IPetOwnerRepository _petOwnerRepository;

        public GetAllPetOwnersQueryHandler(IMapper mapper, IPetOwnerRepository petOwnerRepository)
        {
            _mapper = mapper;
            _petOwnerRepository = petOwnerRepository;
        }

        public async Task<List<PetOwnerResponse>> Handle(GetAllPetOwnersQuery request, CancellationToken cancellationToken)
        {
            var petOwners = await _petOwnerRepository.GetAllAsync();
            return _mapper.Map<List<PetOwnerResponse>>(petOwners);
        }
    }
}
