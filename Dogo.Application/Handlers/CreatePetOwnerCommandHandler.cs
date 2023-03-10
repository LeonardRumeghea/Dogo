﻿using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Enitities;
using MediatR;

#nullable disable
namespace Dogo.Application.Handlers
{
    public class CreatePetOwnerCommandHandler : IRequestHandler<CreatePetOwnerCommand, PetOwnerResponse>
    {
        private readonly IUnitOfWork unitOfWork;

        public CreatePetOwnerCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<PetOwnerResponse> Handle(CreatePetOwnerCommand request, CancellationToken cancellationToken)
        {
            var petOwnerEntity = PetOwnerMapper.Mapper.Map<PetOwner>(request);
            if (petOwnerEntity == null)
            {
                return null;
            }
            
            //petOwnerEntity.Address = await unitOfWork.AddressRepository.AddAsync(petOwnerEntity.Address);

            var newPetOwner = await unitOfWork.PetOwnerRepository.AddAsync(petOwnerEntity);

            return PetOwnerMapper.Mapper.Map<PetOwnerResponse>(newPetOwner);
        }
    }
}
