using Dogo.Core.Helpers;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.PetOwner
{
    public class CheckLoginQueryHandler : IRequestHandler<CheckLoginQuery, ResultOfEntity<Core.Entities.PetOwner>>
    {
        private readonly IPetOwnerRepository _petOwnerRepository;

        public CheckLoginQueryHandler(IPetOwnerRepository petOwnerRepository) 
            => _petOwnerRepository = petOwnerRepository;

        public async Task<ResultOfEntity<Core.Entities.PetOwner>> Handle(CheckLoginQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await _petOwnerRepository.GetByEmail(request.Email);

            if (petOwner == null)
            {
                return ResultOfEntity<Core.Entities.PetOwner>.Failure(HttpStatusCode.NotFound, "Pet owner not found");
            }

            if (!petOwner.Password.Equals(request.Password))
            {
                return ResultOfEntity<Core.Entities.PetOwner>.Failure(HttpStatusCode.Unauthorized, "Invalid password");
            }

            return ResultOfEntity<Core.Entities.PetOwner>.Success(HttpStatusCode.OK, petOwner);
        }
    }
}
