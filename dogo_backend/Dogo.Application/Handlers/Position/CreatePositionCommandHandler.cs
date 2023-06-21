using Dogo.Application.Commands.Position;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Handlers.Position
{
    public class CreatePositionCommandHandler : IRequestHandler<CreatePositionCommand, ResultOfEntity<PositionResponse>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public CreatePositionCommandHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<PositionResponse>> Handle(CreatePositionCommand request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
            {
                return ResultOfEntity<PositionResponse>.Failure(HttpStatusCode.NotFound, "User not found.");
            }

            var position = new Core.Entities.Position
            {
                UserId = request.UserId,
                Latitude = request.Latitude,
                Longitude = request.Longitude
            };

            await _unitOfWork.PositionsRepository.AddAsync(position);

            return ResultOfEntity<PositionResponse>.Success(HttpStatusCode.Created, PositionMapper.Mapper.Map<PositionResponse>(position));
        }
    }
}
