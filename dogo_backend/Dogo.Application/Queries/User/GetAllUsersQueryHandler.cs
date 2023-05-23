using Dogo.Application.Mappers;
using Dogo.Application.Response;
using MediatR;

namespace Dogo.Application.Queries.User
{
    public class GetAllUsersQueryHandler : IRequestHandler<GetAllUsersQuery, List<UserResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAllUsersQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<List<UserResponse>> Handle(GetAllUsersQuery request, CancellationToken cancellationToken) 
            => UserMapper.Mapper.Map<List<UserResponse>>(await unitOfWork.UsersRepository.GetAllAsync());
    }
}
