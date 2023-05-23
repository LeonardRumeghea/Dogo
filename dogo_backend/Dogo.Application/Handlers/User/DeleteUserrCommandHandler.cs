using Dogo.Application.Commands.User;
using Dogo.Core.Helpers;
using MediatR;

#nullable disable
namespace Dogo.Application.Handlers.User
{
    public class DeleteUserrCommandHandler : IRequestHandler<DeleteUserCommand, HttpStatusCode>
    {
        private readonly IUnitOfWork unitOfWork;

        public DeleteUserrCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<HttpStatusCode> Handle(DeleteUserCommand request, CancellationToken cancellationToken)
        {
            var petOwner = await unitOfWork.UsersRepository.GetByIdAsync(request.Id);

            if (petOwner == null)
            {
                return HttpStatusCode.NotFound;
            }

            petOwner.Pets.ForEach(pet => unitOfWork.PetRepository.DeleteAsync(pet));

            await unitOfWork.UsersRepository.DeleteAsync(petOwner);

            return HttpStatusCode.NoContent;
        }
    }
}
