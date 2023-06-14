#nullable disable
namespace Dogo.Application.Response
{
    public class UserPreferencesResponse
    {

        public Guid UserId { get; set; }
        // Pets preferences
        public string DogPreference { get; set; }
        public string CatPreference { get; set; }
        public string RabbitPreference { get; set; }
        public string BirdPreference { get; set; }
        public string FishPreference { get; set; }
        public string FerretPreference { get; set; }
        public string GuineaPigPreference { get; set; }
        public string OtherPreference { get; set; }

        // Activities Preferences
        public string WalkPreference { get; set; }
        public string VetPreference { get; set; }
        public string SalonPreference { get; set; }
        public string SitPreference { get; set; }
        public string ShoppingPreference { get; set; }
    }
}
