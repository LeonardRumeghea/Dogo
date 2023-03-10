using Dogo.Application.Commands.PetOwner;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Handlers
{
    public class DeletePetOwnerCommandHandler : IRequestHandler<DeletePetOwnerCommand, bool>
    {
        private readonly IPetOwnerRepository _petOwnerRepository;

        public DeletePetOwnerCommandHandler(IPetOwnerRepository petOwnerRepository)
        {
            _petOwnerRepository = petOwnerRepository;
        }

        public async Task<bool> Handle(DeletePetOwnerCommand request, CancellationToken cancellationToken)
        {
            var petOwner = await _petOwnerRepository.GetByIdAsync(request.Id);

            if (petOwner == null)
            {
                return false;
            }

            await _petOwnerRepository.DeleteAsync(petOwner);

            return true;
        }
    }
}
