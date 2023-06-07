using Dogo.Application.Commands.Pet;
using Dogo.Application.Commands.User;
using Dogo.Application.Queries.User;
using Dogo.Application.Queries.PetOwner.Pets;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/users")]
    [ApiController]
    [ApiVersion("1.0")]
    public class UsersController : ControllerBase
    {
        private readonly IMediator _mediator;

        public UsersController(IMediator mediator) => _mediator = mediator;


        // Work with petOwner account
        // Done - GetAll, GetByID, Create, Delete, Update
        // Work in progress - 
        [HttpPost]
        public IActionResult CreatePetOwner([FromBody] CreateUserCommand command)
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
            var response = await _mediator.Send(new GetUserByIdQuery { Id = id });

            return response.IsSuccess ? Ok(response.Entity) : StatusCode((int)response.StatusCode, response.Message);
        }

        [HttpGet(Name = "GetUsers")]
        public async Task<List<UserResponse>> GetUsers() => await _mediator.Send(new GetAllUsersQuery());

        [HttpGet("checkLogin")]
        public IActionResult CheckLogin([FromQuery] CheckLoginQuery query)
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
        public async Task<IActionResult> UpdateUser(Guid id, [FromBody] UpdateUserCommand command)
        {
            var response = await _mediator.Send(new UpdateUserQuery { Id = id, PetOwner = command });

            return response.IsSuccess ? NoContent() : StatusCode((int)response.StatusCode, response.Message);
        }


        [HttpDelete("{id}", Name = "DeleteUser")]
        public async Task<IActionResult> DeleteUser(Guid id)
        {
            var result = await _mediator.Send(new DeleteUserCommand(id));
            return result == HttpStatusCode.NotFound ? NotFound() : NoContent();
        }


        // Work with pets of pet owner
        // Done - GetAll, GetById, Create, Delete, Update
        // Work in progress -  
        [HttpGet("{id}/pets")]
        public async Task<List<PetResponse>> GetPetsOfUser(Guid id) => await _mediator.Send(new GetAllPetOfUser { PetOwnerId = id });

        [HttpGet("{id}/pets/{petId}")]
        public async Task<IActionResult> GetPetOfUser(Guid id, Guid petId)
        {
            var result = await _mediator.Send(new GetPetByIdQuery { PetOwnerId = id, PetId = petId });

            return result.IsFailure ? NotFound(result.Message) : Ok(result.Entity);
        }

        [HttpPost("{id}/pet")]
        public async Task<IActionResult> AddPetToUser(Guid id, [FromBody] CreatePetCommand command)
        {
            var response = await _mediator.Send(new AddPetToPetUserQuery { PetOwnerId = id, Pet = command });

            return response.IsSuccess ? Created(nameof(GetPetOfUser), response.Entity) : StatusCode((int)response.StatusCode, response.Message);

            //if (response.StatusCode == HttpStatusCode.NotFound) return NotFound();
            //else if (response.StatusCode == HttpStatusCode.BadRequest) return BadRequest();
            //else return Created("GetPetOwners", response.Entity);
        }

        [HttpPut("{id}/pet/{petId}")]
        public async Task<IActionResult> UpdatePetOfUser(Guid id, Guid petId, [FromBody] UpdatePetCommand command)
        {
            var response = await _mediator.Send(new UpdatePetQuery { PetOwnerId = id, PetId = petId, Pet = command });

            return response.IsSuccess ? NoContent() : StatusCode((int)response.StatusCode, response.Message);
        }

        [HttpDelete("{id}/pet/{petId}")]
        public async Task<IActionResult> RemovePetFromUser(Guid id, Guid petId)
        {
            var response = await _mediator.Send(new RemovePetFromUser { PetOwnerId = id, PetId = petId });

            return response.IsSuccess ? NoContent() : StatusCode((int)response.StatusCode, response.Message);
        }
    }
}
