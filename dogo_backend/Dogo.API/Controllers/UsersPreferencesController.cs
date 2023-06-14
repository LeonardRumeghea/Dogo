using Dogo.Application.Commands.User.Preferences;
using Dogo.Application.Queries.UserPreferences;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/preferences")]
    [ApiController]
    [ApiVersion("1.0")]
    public class UsersPreferencesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public UsersPreferencesController(IMediator mediator) => _mediator = mediator;

        [HttpGet("{id:Guid}")]
        public async Task<IActionResult> Get(Guid id)
        {
            var result = await _mediator.Send(new GetUserPreferencesQuery { Id = id });

            return result.IsFailure ? NotFound(result.Message) : Ok(result.Entity);
        }

        [HttpPut("update")]
        public IActionResult Update(UpdateUserPreferencesCommand command)
        {
            var result = _mediator.Send(command).Result;

            return result.IsSuccess ? NoContent() : BadRequest();
        }
    }
}
