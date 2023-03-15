using Dogo.Application.Mappers;
using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class GetAllPetOwnersQueryHandler : IRequestHandler<GetAllPetOwnersQuery, List<PetOwnerResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAllPetOwnersQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<List<PetOwnerResponse>> Handle(GetAllPetOwnersQuery request, CancellationToken cancellationToken) 
            => PetOwnerMapper.Mapper.Map<List<PetOwnerResponse>>(await unitOfWork.PetOwnerRepository.GetAllAsync());
    }
}
