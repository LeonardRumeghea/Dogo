using Dogo.Application.Commands.Walker;
using Dogo.Application.Queries.Walker;
using Dogo.Application.Response;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/walkers")]
    [ApiController]
    [ApiVersion("1.0")]
    public class WalkersController : ControllerBase
    {
        private readonly IMediator _mediator;

        public WalkersController(IMediator mediator) => _mediator = mediator;

        // Work with walker account
        // Done - GetAll, GetByID, Create, Delete, Update
        // Work in progress - 

        [HttpPost]
        public async Task<IActionResult> CreateWalker([FromBody] CreateWalkerCommand command)
        {
            return Created("GetAllWalkers", await _mediator.Send(command));
        }

        [HttpGet]
        public async Task<List<WalkerResponse>> GetAllWalkers()
        {
            return await _mediator.Send(new GetAllWalkersQuery());
        }

        [HttpGet("{id:Guid}")]
        public async Task<IActionResult> GetWalker(Guid id)
        {
            var response = await _mediator.Send(new GetWalkerByIdQuery { Id = id });
            return response == null ? NotFound() : Ok(response);
        }

        [HttpPut("{id:Guid}")]
        public async Task<IActionResult> UpdateWalker(Guid id, [FromBody] UpdateWalkerCommand command)
        {
            var response = await _mediator.Send(new UpdateWalkerQuery { WalkerId = id, Walker = command });
            return response.IsSuccess ? NoContent() : StatusCode((int)response.StatusCode, response.Message);
        }

        [HttpDelete("{id:Guid}")]
        public async Task<IActionResult> DeleteWalker(Guid id)
        {
            var result = await _mediator.Send(new DeleteWalkerQuery { Id = id });
            return result.IsSuccess ? NoContent() : StatusCode((int)result.StatusCode, result.Message);
        }
    }
}
