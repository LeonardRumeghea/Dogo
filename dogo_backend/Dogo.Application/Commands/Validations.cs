using Dogo.Core.Entities;
using Dogo.Core.Enums;
using Dogo.Core.Enums.Species;
using Dogo.Core.Enums.Species.Breeds;
using System.Text.RegularExpressions;

namespace Dogo.Application.Commands
{
    public static class Validations
    {
        public static bool BeValidDate(string value) => DateTime.TryParse(value, out var date) && date < DateTime.Now;

        public static bool BeValidDateAppointment(string value) => DateTime.TryParse(value, out var date) && date > DateTime.Now;

        public static bool BeValidUntilDateAppointment(string value)
        {
            if (value == null || value == "") return true;

            return DateTime.TryParse(value, out var date) && date > DateTime.Now;
        }

        public static bool BeValidAppointmentDuration(int value) => value == 0 || (value >= 1 && value <= 1440);

        public static bool BeValidAppointmentType(string value) => Enum.TryParse(value, out AppointmentType _);

        public static bool BeInPetGenderEnum(string value) => Enum.TryParse<PetGender>(value, out _);

        public static bool BeInSpeciesEnum(string value) => Enum.TryParse<Specie>(value, out _);

        public static bool BeRightBreed(string specie, string breed)
        {
            return specie switch
            {
                "Dog" => Enum.TryParse<DogBreeds>(breed, out _),
                "Cat" => Enum.TryParse<CatBreeds>(breed, out _),
                "Bird" => Enum.TryParse<BirdBreeds>(breed, out _),
                "Fish" => Enum.TryParse<FishBreeds>(breed, out _),
                "GuineaPig" => Enum.TryParse<GuineaPigsBreeds>(breed, out _),
                "Ferret" => Enum.TryParse<FerretsBreeds>(breed, out _),
                "Rabbit" => Enum.TryParse<RabbitBreeds>(breed, out _),
                "Other" => true,
                _ => false
            };
        }

        public static bool BeValidGuid(Guid value) {
            Regex re = new(@"^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$");
            return re.IsMatch(value.ToString());
        }
    }
}
