using Dogo.Core.Enums.Species.Breeds;
using MediatR;

namespace Dogo.Application.Queries.Enums
{
    public class GetAllBreedsOfSpecieQueryHandler : IRequestHandler<GetAllBreedsOfSpecieQuery, List<string>>
    {
        public Task<List<string>> Handle(GetAllBreedsOfSpecieQuery request, CancellationToken cancellationToken)
        {
            var specie = request.Specie;
            var result = new List<string>();
            switch (specie)
            {
                case "Dog":
                    result = Enum.GetNames(enumType: typeof(DogBreeds)).ToList();
                    break;
                case "Cat":
                    result = Enum.GetNames(enumType: typeof(CatBreeds)).ToList();
                    break;
                case "Bird":
                    result = Enum.GetNames(enumType: typeof(BirdBreeds)).ToList();
                    break;
                case "Fish":
                    result = Enum.GetNames(enumType: typeof(FishBreeds)).ToList();
                    break;
                case "Ferret":
                    result = Enum.GetNames(enumType: typeof(FerretsBreeds)).ToList();
                    break;
                case "Rabbit":
                    result = Enum.GetNames(enumType: typeof(RabbitBreeds)).ToList();
                    break;
                case "GuineaPig":
                    result = Enum.GetNames(enumType: typeof(GuineaPigsBreeds)).ToList();
                    break;
                case "Other":
                    result = new List<string>() { "Other" };
                    break;
            }
            return Task.FromResult(result);
        }
    }
}
