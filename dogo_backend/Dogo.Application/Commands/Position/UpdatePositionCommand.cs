using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Commands.Position
{
    public class UpdatePositionCommand : IRequest<ResultOfEntity<PositionResponse>>
    {
        public Guid UserId { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
