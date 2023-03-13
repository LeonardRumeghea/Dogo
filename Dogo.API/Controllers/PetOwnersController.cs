using Dogo.Application.Commands.Pet;
using Dogo.Application.Commands.PetOwner;
using Dogo.Application.Queries.PetOwner;
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
        // Done - GetAll, GetByID, Create, Delete
        // Work in progress - Update
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
            var result = await _mediator.Send(new DeletePetOwnerCommand(id));
            return result == HttpStatusCodeResponse.NotFound ? NotFound() : NoContent();
        }


        // Work with pets of pet owner
        // Done - GetAll, GetById, Create
        // Work in progress - Update, Delete
        [HttpGet("{id}/pets")]
        public async Task<List<PetResponse>> GetPetsOfOwner(Guid id) 
            => await _mediator.Send(new GetAllPetOfOwner { PetOwnerId = id });

        [HttpGet("{id}/pets/{petId}")]
        public async Task<PetResponse> GetPetOfOwner(Guid id, Guid petId)
            => (await _mediator.Send(new GetPetByIdQuery { PetOwnerId = id, PetId = petId })).Entity;

        [HttpPost("{id}/pet")]
        public async Task<IActionResult> AddPetToOwner(Guid id, [FromBody] CreatePetCommand command)
        {
            var response = await _mediator.Send(new AddPetToPetOwnerQuery { PetOwnerId = id, Pet = command });

            if (response.httpStatusCode == HttpStatusCodeResponse.NotFound) return NotFound();
            else if (response.httpStatusCode == HttpStatusCodeResponse.BadRequest) return BadRequest();
            else return Created("GetPetOwners", response.Entity);
        }

        [HttpDelete("{id}/pet/{petId}")]
        public async Task<IActionResult> RemovePetFromOwner(Guid id, Guid petId)
        {
            var response = await _mediator.Send(new RemovePetFromOwner { PetOwnerId = id, PetId = petId });

            return response == HttpStatusCodeResponse.NotFound ? NotFound() : NoContent();
        }
    }
}
