using Dogo.Application.Queries.Pet;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/pets")]
    [ApiController]
    [ApiVersion("1.0")]
    public class PetsController : ControllerBase
    {
        private readonly IMediator _medator;

        public PetsController(IMediator medator) => _medator = medator;


        [HttpGet("{id:Guid}")]
        public async Task<IActionResult> GetById([FromRoute] Guid id)
        {
            var result = await _medator.Send(new GetPetByIdQuery { PetId = id });
            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }
    }
}
