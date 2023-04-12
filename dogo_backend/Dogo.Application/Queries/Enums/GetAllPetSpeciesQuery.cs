using MediatR;

namespace Dogo.Application.Queries.Enums
{
    public class GetAllPetSpeciesQuery : IRequest<List<string>> { }
}
