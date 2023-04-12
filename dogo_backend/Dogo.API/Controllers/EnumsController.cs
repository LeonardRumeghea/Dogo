using Dogo.Application.Queries.Enums;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/appointments")]
    [ApiController]
    [ApiVersion("1.0")]
    public class EnumsController
    {
        private readonly IMediator _medator;

        public EnumsController(IMediator medator) => _medator = medator;

        [HttpGet("species")]
        public async Task<List<string>> GetSpecies() 
            => await _medator.Send(new GetAllPetSpeciesQuery());

        [HttpGet("breeds")]
        public async Task<List<string>> GetBreeds(string specie) 
            => await _medator.Send(new GetAllBreedsOfSpecieQuery { Specie = specie });
    }
}
