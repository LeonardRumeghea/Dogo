using Dogo.Application.Commands.Pet;
using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Queries.PetOwner;
using Dogo.Application.Queries.PetOwner.Pets;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
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


        // Work with petOwner account
        // Done - GetAll, GetByID, Create, Delete, Update
        // Work in progress - 
        [HttpPost]
        public async Task<IActionResult> CreatePetOwner([FromBody] CreatePetOwnerCommand command)
        {
            var result = _mediator.Send(command).Result;

            return result.StatusCode switch
            {
                HttpStatusCode.Conflict => Conflict(result.Message),
                HttpStatusCode.BadRequest => BadRequest(result.Message),
                HttpStatusCode.Created => Created(nameof(GetPetOwner), result.Entity),
                _ => BadRequest(result.Message)
            };
        }

        [HttpGet("{id:Guid}")]
        public async Task<IActionResult> GetPetOwner(Guid id)
        {
            var response = await _mediator.Send(new GetPetOwnerByIdQuery { Id = id });

            return response.IsSuccess ? Ok(response.Entity) : StatusCode((int)response.StatusCode, response.Message);
        }

        [HttpGet(Name = "GetPetOwners")]
        public async Task<List<PetOwnerResponse>> GetPetOwners() => await _mediator.Send(new GetAllPetOwnersQuery());

        [HttpGet("checkLogin")]
        public async Task<IActionResult> CheckLogin([FromQuery] CheckLoginQuery query)
        {
            var result = _mediator.Send(query).Result;

            return result.StatusCode switch
            {
                HttpStatusCode.NotFound => NotFound(result.Message),
                HttpStatusCode.Unauthorized => Unauthorized(result.Message),
                HttpStatusCode.OK => Ok(result.Entity),
                _ => Conflict()
            };
        }

        [HttpPut("{id:Guid}")]
        public async Task<IActionResult> UpdatePetOwner(Guid id, [FromBody] UpdatePetOwnerCommand command)
        {
            var response = await _mediator.Send(new UpdatePetOwnerQuery { Id = id, PetOwner = command });

            return response.IsSuccess ? NoContent() : StatusCode((int)response.StatusCode, response.Message);
        }


        [HttpDelete("{id}", Name = "DeletePetOwner")]
        public async Task<IActionResult> DeletePetOwner(Guid id)
        {
            var result = await _mediator.Send(new DeletePetOwnerCommand(id));
            return result == HttpStatusCode.NotFound ? NotFound() : NoContent();
        }


        // Work with pets of pet owner
        // Done - GetAll, GetById, Create, Delete, Update
        // Work in progress -  
        [HttpGet("{id}/pets")]
        public async Task<List<PetResponse>> GetPetsOfOwner(Guid id) 
            => await _mediator.Send(new GetAllPetOfOwner { PetOwnerId = id });

        [HttpGet("{id}/pets/{petId}")]
        public async Task<IActionResult> GetPetOfOwner(Guid id, Guid petId)
        {
            var result = await _mediator.Send(new GetPetByIdQuery { PetOwnerId = id, PetId = petId });

            return result.IsFailure ? NotFound(result.Message) : Ok(result.Entity);
        }

        [HttpPost("{id}/pet")]
        public async Task<IActionResult> AddPetToOwner(Guid id, [FromBody] CreatePetCommand command)
        {
            var response = await _mediator.Send(new AddPetToPetOwnerQuery { PetOwnerId = id, Pet = command });

            if (response.StatusCode == HttpStatusCode.NotFound) return NotFound();
            else if (response.StatusCode == HttpStatusCode.BadRequest) return BadRequest();
            else return Created("GetPetOwners", response.Entity);
        }

        [HttpPut("{id}/pet/{petId}")]
        public async Task<IActionResult> UpdatePetOfOwner(Guid id, Guid petId, [FromBody] UpdatePetCommand command)
        {
            var response = await _mediator.Send(new UpdatePetQuery { PetOwnerId = id, PetId = petId, Pet = command });

            return response.IsSuccess ? NoContent() : StatusCode((int)response.StatusCode, response.Message);
        }

        [HttpDelete("{id}/pet/{petId}")]
        public async Task<IActionResult> RemovePetFromOwner(Guid id, Guid petId)
        {
            var response = await _mediator.Send(new RemovePetFromOwner { PetOwnerId = id, PetId = petId });

            return response.IsSuccess ? NoContent() : StatusCode((int)response.StatusCode, response.Message);
        }
    }
}
