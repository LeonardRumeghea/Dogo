using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetPetOwnerByIdQueryHandler : IRequestHandler<GetPetOwnerByIdQuery, ResultOfEntity<PetOwnerResponse>>
    {
        private readonly IPetOwnerRepository _petOwnerRepository;

        public GetPetOwnerByIdQueryHandler(IPetOwnerRepository petOwnerRepository) 
            => _petOwnerRepository = petOwnerRepository;

        public async Task<ResultOfEntity<PetOwnerResponse>> Handle(GetPetOwnerByIdQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await _petOwnerRepository.GetByIdAsync(request.Id);

            if (petOwner == null)
                return ResultOfEntity<PetOwnerResponse>.Failure(HttpStatusCode.NotFound, "Pet owner not found");

            return ResultOfEntity<PetOwnerResponse>.Success(
                HttpStatusCode.OK,
                PetOwnerMapper.Mapper.Map<PetOwnerResponse>(petOwner)
            );
        }
    }
}
