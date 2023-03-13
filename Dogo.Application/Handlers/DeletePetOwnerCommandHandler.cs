using Dogo.Application.Commands.PetOwner;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Handlers
{
    public class DeletePetOwnerCommandHandler : IRequestHandler<DeletePetOwnerCommand, HttpStatusCodeResponse>
    {
        private readonly IUnitOfWork unitOfWork;

        public DeletePetOwnerCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<HttpStatusCodeResponse> Handle(DeletePetOwnerCommand request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.Id);

            if (petOwner == null)
            {
                return HttpStatusCodeResponse.NotFound;
            }

            petOwner.Pets.ForEach(pet => unitOfWork.PetRepository.DeleteAsync(pet));

            await unitOfWork.PetOwnerRepository.DeleteAsync(petOwner);

            return HttpStatusCodeResponse.NoContent;
        }
    }
}
