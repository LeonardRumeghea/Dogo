using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Position
{
    public class GetPositionOfUserQueryHandler : IRequestHandler<GetPositionOfUserQuery, ResultOfEntity<PositionResponse>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public GetPositionOfUserQueryHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PositionResponse>> Handle(GetPositionOfUserQuery request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
            {
                return ResultOfEntity<PositionResponse>.Failure(HttpStatusCode.NotFound, "User not found.");
            }

            var position = await _unitOfWork.PositionsRepository.getByUserId(request.UserId);
            if (position == null)
            {
                return ResultOfEntity<PositionResponse>.Failure(HttpStatusCode.NotFound, "Position not found.");
            }

            return ResultOfEntity<PositionResponse>.Success(HttpStatusCode.OK, PositionMapper.Mapper.Map<PositionResponse>(position));
        }
    }
}
