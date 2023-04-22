using Dogo.Application.Commands.Walker;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Repositories.Base;
using MediatR;

namespace Dogo.Application.Handlers.Walker
{
    public class CreateWalkerCommandHandler : IRequestHandler<CreateWalkerCommand, WalkerResponse>
    {
        private readonly IUnitOfWork unitOfWork;

        public CreateWalkerCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<WalkerResponse> Handle(CreateWalkerCommand request, CancellationToken cancellationToken)
        {
            var petOwner = unitOfWork.PetOwnerRepository.GetByIdAsync(Guid.Parse(request.Id)).Result;
            if (petOwner == null)
            {
                throw new ApplicationException("PetOwner not found");
            }

            var walker = new Core.Entities.Walker
            {
                FirstName = petOwner.FirstName,
                LastName = petOwner.LastName,
                Email = petOwner.Email,
                Password = petOwner.Password,
                PhoneNumber = petOwner.PhoneNumber,
                Address = petOwner.Address,
            };

            var response = await unitOfWork.WalkerRepository.AddAsync(walker);

            response.Id = walker.Id;

            await unitOfWork.WalkerRepository.UpdateAsync(response);

            return WalkerMapper.Mapper.Map<WalkerResponse>(response);
        }
    }
}
