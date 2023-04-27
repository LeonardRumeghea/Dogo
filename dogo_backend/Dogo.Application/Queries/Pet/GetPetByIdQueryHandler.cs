using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Pet
{
    public class GetPetByIdQueryHandler : IRequestHandler<GetPetByIdQuery, ResultOfEntity<PetResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetPetByIdQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PetResponse>> Handle(GetPetByIdQuery request, CancellationToken cancellationToken)
        {
            var pet = await unitOfWork.PetRepository.GetByIdAsync(request.PetId);
            if (pet == null)
            {
                return ResultOfEntity<PetResponse>.Failure(HttpStatusCode.NotFound, "Pet not found");
            }

            var petResponse = PetMapper.Mapper.Map<PetResponse>(pet);

            return ResultOfEntity<PetResponse>.Success(HttpStatusCode.OK, petResponse);
        }
    }
}
