using Dogo.Application.Mappers;
using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class GetAllPetOfOwnerHandler : IRequestHandler<GetAllPetOfOwner, List<PetResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAllPetOfOwnerHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<List<PetResponse>> Handle(GetAllPetOfOwner request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.PetOwnerId);

            if (petOwner == null)
            {
                return new List<PetResponse>();
            }

            return PetMapper.Mapper.Map<List<PetResponse>>(petOwner.Pets);
        }
    }
}
