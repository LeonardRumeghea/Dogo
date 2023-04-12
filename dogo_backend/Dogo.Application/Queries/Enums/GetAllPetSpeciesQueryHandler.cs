using Dogo.Core.Enums.Species;
using MediatR;

namespace Dogo.Application.Queries.Enums
{
    public class GetAllPetSpeciesQueryHandler : IRequestHandler<GetAllPetSpeciesQuery, List<string>>
    {
        public Task<List<string>> Handle(GetAllPetSpeciesQuery request, CancellationToken cancellationToken)
        {
            return Task.FromResult(Enum.GetNames(enumType: typeof(Specie)).ToList());
        }
    }
}
