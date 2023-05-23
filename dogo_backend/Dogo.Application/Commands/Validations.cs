using Dogo.Core.Entities;
using Dogo.Core.Enums;
using Dogo.Core.Enums.Species;
using Dogo.Core.Enums.Species.Breeds;
using System.Text.RegularExpressions;

namespace Dogo.Application.Commands
{
    public static partial class Validations
    {
        public static bool BeValidDateOfBirth(string value) => DateTime.TryParse(value, out var date) && date < DateTime.Now;

        public static bool BeValidAppointmentDate(string value) => DateTime.TryParse(value, out var date) && date > DateTime.Now;

        public static bool BeValidUntilDateAppointment(string value) 
            => value == null || value == "" || (DateTime.TryParse(value, out DateTime date) && date > DateTime.Now);

        public static bool BeValidAppointmentDuration(int value) => value >= 0 && value <= 1440;

        public static bool BeValidAppointmentType(string value) => Enum.TryParse(value, out AppointmentType _);

        public static bool BeInPetGenderEnum(string value) => Enum.TryParse<PetGender>(value, out _);

        public static bool BeInSpeciesEnum(string value) => Enum.TryParse<Specie>(value, out _);

        public static bool BeValidBreed(string specie, string breed)
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

        public static bool BeValidPreference(string value) => Enum.TryParse(value, out PreferenceDegree _);

        public static bool BeValidGuid(Guid value) => GuidRegex().IsMatch(value.ToString());

        [GeneratedRegex("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$")]
        private static partial Regex GuidRegex();
    }
}
