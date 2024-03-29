﻿using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.PetOwner.Pets
{
    public class GetPetByIdQueryHandler : IRequestHandler<GetPetByIdQuery, ResultOfEntity<PetResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetPetByIdQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PetResponse>> Handle(GetPetByIdQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.UsersRepository.GetByIdAsync(request.PetOwnerId);

            if (petOwner == null)
            {
                return ResultOfEntity<PetResponse>.Failure(HttpStatusCode.NotFound, "Pet Owner not found");
            }

            var pet = petOwner.Pets.FirstOrDefault(p => p.Id == request.PetId);

            if (pet == null)
            {
                return ResultOfEntity<PetResponse>.Failure(HttpStatusCode.NotFound, "Pet not found");
            }

            return ResultOfEntity<PetResponse>.Success(HttpStatusCode.OK, PetMapper.Mapper.Map<PetResponse>(pet));
        }
    }
}
