using MediatR;

namespace Dogo.Application.Queries.Enums
{
    public class GetAllBreedsOfSpecieQuery : IRequest<List<string>> 
    {
        public string? Specie { get; set; }
    }
}
