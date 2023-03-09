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

        [HttpPost(Name = "CreatePetOwner")]
        public async Task<IActionResult> CreatePetOwner([FromBody] CreatePetOwnerCommand command)
        {
            var response = await _mediator.Send(command);
            //return CreatedAtRoute("GetPetOwner", new { id = response.Id }, response);
            return Created("GetPetOwners", response);
        }

        //[HttpGet("{id}", Name = "GetPetOwner")]
        //public async Task<IActionResult> GetPetOwner(int id)
        //{
        //    var response = await _mediator.Send(new GetPetOwnerByIdQuery { Id = id });
        //    return Ok(response);
        //}

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
