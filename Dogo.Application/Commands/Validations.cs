using Dogo.Core.Enums;
using Dogo.Core.Enums.Species;
using Dogo.Core.Enums.Species.Breeds;

namespace Dogo.Application.Commands
{
    public static class Validations
    {
        public static bool BeValidDate(string value) => DateTime.TryParse(value, out var date) && date < DateTime.Now;

        public static bool BeInPetGenderEnum(string value) => Enum.TryParse<PetGender>(value, out _);

        public static bool BeInSpeciesEnum(string value) => Enum.TryParse<Specie>(value, out _);

        public static bool BeRightBreed(String specie, string breed)
        {
            if (specie == "Dog")
            {
                return Enum.TryParse<DogBreeds>(breed, out _);
            }
            else if (specie == "Cat")
            {
                return Enum.TryParse<CatBreeds>(breed, out _);
            }
            else if (specie == "Bird")
            {
                return Enum.TryParse<BirdBreeds>(breed, out _);
            }
            else if (specie == "Fish")
            {
                return Enum.TryParse<FishBreeds>(breed, out _);
            }
            else if (specie == "guineaPigs")
            {
                return Enum.TryParse<GuineaPigsBreeds>(breed, out _);
            }
            else if (specie == "Rabbit")
            {
                return Enum.TryParse<RabbitBreeds>(breed, out _);
            }
            else if (specie == "Other")
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
