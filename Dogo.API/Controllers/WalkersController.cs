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
        // Done - GetAll, GetByID, Create, Delete
        // Work in progress - Update

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

            if (response == null)
            {
                return NotFound();
            }

            return Ok(response);
        }

        [HttpDelete("{id:Guid}")]
        public async Task<IActionResult> DeleteWalker(Guid id)
        {
            await _mediator.Send(new DeleteWalkerQuery { Id = id });
            return NoContent();
        }
    }
}
