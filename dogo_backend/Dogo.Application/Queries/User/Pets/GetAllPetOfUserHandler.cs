using Dogo.Application.Mappers;
using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class GetAllPetOfUserHandler : IRequestHandler<GetAllPetOfUser, List<PetResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAllPetOfUserHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<List<PetResponse>> Handle(GetAllPetOfUser request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.UsersRepository.GetByIdAsync(request.PetOwnerId);

            if (petOwner == null)
            {
                return new List<PetResponse>();
            }

            return PetMapper.Mapper.Map<List<PetResponse>>(petOwner.Pets);
        }
    }
}
