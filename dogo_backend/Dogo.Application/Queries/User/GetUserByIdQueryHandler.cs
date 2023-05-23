using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.User
{
    public class GetUserByIdQueryHandler : IRequestHandler<GetUserByIdQuery, ResultOfEntity<UserResponse>>
    {
        private readonly IUserRepository _petOwnerRepository;

        public GetUserByIdQueryHandler(IUserRepository petOwnerRepository) 
            => _petOwnerRepository = petOwnerRepository;

        public async Task<ResultOfEntity<UserResponse>> Handle(GetUserByIdQuery request, CancellationToken cancellationToken)
        {
            var petOwner = await _petOwnerRepository.GetByIdAsync(request.Id);

            if (petOwner == null)
                return ResultOfEntity<UserResponse>.Failure(HttpStatusCode.NotFound, "Pet owner not found");

            return ResultOfEntity<UserResponse>.Success(
                HttpStatusCode.OK,
                UserMapper.Mapper.Map<UserResponse>(petOwner)
            );
        }
    }
}
