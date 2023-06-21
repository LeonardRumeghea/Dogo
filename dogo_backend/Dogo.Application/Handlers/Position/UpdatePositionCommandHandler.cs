using Dogo.Application.Commands.Position;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Handlers.Position
{
    public class UpdatePositionCommandHandler : IRequestHandler<UpdatePositionCommand, ResultOfEntity<PositionResponse>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public UpdatePositionCommandHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PositionResponse>> Handle(UpdatePositionCommand request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
            {
                return ResultOfEntity<PositionResponse>.Failure(HttpStatusCode.NotFound, "User not found.");
            }

            var position = await _unitOfWork.PositionsRepository.getByUserId(request.UserId);
            if (position == null)
            {
                //return ResultOfEntity<PositionResponse>.Failure(HttpStatusCode.NotFound, "Position not found.");
                position = new Core.Entities.Position
                {
                    UserId = request.UserId,
                    Latitude = request.Latitude,
                    Longitude = request.Longitude
                };

                await _unitOfWork.PositionsRepository.AddAsync(position);
            }

            position!.Latitude = request.Latitude;
            position!.Longitude = request.Longitude;

            await _unitOfWork.PositionsRepository.UpdateAsync(position);

            return ResultOfEntity<PositionResponse>.Success(HttpStatusCode.OK, PositionMapper.Mapper.Map<PositionResponse>(position));
        }
    }
}
