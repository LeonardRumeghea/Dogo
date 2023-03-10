using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Queries.PetOwner;
using Dogo.Application.Response;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/petOwners")]
    [ApiController]
    [ApiVersion("1.0")]
    public class PetOwnersController : ControllerBase
    {
        private readonly IMediator _mediator;

        public PetOwnersController(IMediator mediator) => _mediator = mediator;

        [HttpPost]
        public async Task<IActionResult> CreatePetOwner([FromBody] CreatePetOwnerCommand command)
        {
            return Created("GetPetOwners", await _mediator.Send(command));
        }

        [HttpGet("{id:Guid}")]
        public async Task<IActionResult> GetPetOwner(Guid id)
        {
            var response = await _mediator.Send(new GetPetOwnerByIdQuery { Id = id });

            if (response == null)
            {
                return NotFound();
            }
            
            return Ok(response);
        }

        [HttpGet(Name = "GetPetOwners")]
        public async Task<List<PetOwnerResponse>> GetPetOwners() => await _mediator.Send(new GetAllPetOwnersQuery());

        [HttpDelete("{id}", Name = "DeletePetOwner")]
        public async Task<IActionResult> DeletePetOwner(Guid id)
        {
            await _mediator.Send(new DeletePetOwnerCommand(id));
            return NoContent();
        }
    }
}
