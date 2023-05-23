using Dogo.Core.Helpers;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.User
{
    public class CheckLoginQueryHandler : IRequestHandler<CheckLoginQuery, ResultOfEntity<Core.Entities.User>>
    {
        private readonly IUserRepository _petOwnerRepository;

        public CheckLoginQueryHandler(IUserRepository petOwnerRepository) 
            => _petOwnerRepository = petOwnerRepository;

        public async Task<ResultOfEntity<Core.Entities.User>> Handle(CheckLoginQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await _petOwnerRepository.GetByEmail(request.Email);

            if (petOwner == null)
            {
                return ResultOfEntity<Core.Entities.User>.Failure(HttpStatusCode.NotFound, "Pet owner not found");
            }

            if (!petOwner.Password.Equals(request.Password))
            {
                return ResultOfEntity<Core.Entities.User>.Failure(HttpStatusCode.Unauthorized, "Invalid password");
            }

            return ResultOfEntity<Core.Entities.User>.Success(HttpStatusCode.OK, petOwner);
        }
    }
}
