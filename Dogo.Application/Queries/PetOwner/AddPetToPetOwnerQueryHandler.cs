using AutoMapper;
using Dogo.Application.Response;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class AddPetToPetOwnerQueryHandler : IRequestHandler<AddPetToPetOwnerQuery, HttpStatusCodeResponse>
    {
        private readonly IMapper _mapper;
        private readonly IPetOwnerRepository _petOwnerRepository;

        public AddPetToPetOwnerQueryHandler(IMapper mapper, IPetOwnerRepository petOwnerRepository)
        {
            _mapper = mapper;
            _petOwnerRepository = petOwnerRepository;
        }

        public async Task<HttpStatusCodeResponse> Handle(AddPetToPetOwnerQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await _petOwnerRepository.GetByIdAsync(request.PetOwnerId);

            if (petOwner == null)
            {
                return HttpStatusCodeResponse.NotFound;
            }

            return HttpStatusCodeResponse.OK;
        }
    }
}
