using Dogo.Application.Commands.Position;
using Dogo.Application.Queries.Position;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/positions")]
    [ApiController]
    [ApiVersion("1.0")]
    public class PositionsController : ControllerBase
    {
        private readonly IMediator _medator;

        public PositionsController(IMediator medator) => _medator = medator;

        [HttpPost]
        public async Task<IActionResult> Create(CreatePositionCommand command)
        {
            var result = await _medator.Send(command);
            
            return result.IsSuccess 
                ? Created(nameof(GetByUserId), result.Entity) 
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpPut]
        public async Task<IActionResult> Update(UpdatePositionCommand command)
        {
            var result = await _medator.Send(command);

            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpGet("{userId:Guid}")]
        public async Task<IActionResult> GetByUserId([FromRoute] Guid userId)
        {
            var result = await _medator.Send(new GetPositionOfUserQuery { UserId = userId });
            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }
    }
}
