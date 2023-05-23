namespace Dogo.Core.Entities
{
    public class UserPreferences
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; } // FK - Preferences of user

        // Pet preferences 
        public PreferenceDegree DogPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree CatPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree RabbitPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree BirdPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree FishPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree FerretPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree GuineaPigPreference { get; set; } = PreferenceDegree.Medium;

        // Activities Preferences
        public PreferenceDegree WalkPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree VetPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree SalonPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree SitPreference { get; set; } = PreferenceDegree.Medium;
        public PreferenceDegree ShoppingPreference { get; set; } = PreferenceDegree.Medium;
    }

    public enum PreferenceDegree
    {
        Low = 0,
        Medium = 1,
        High = 2,
        Unspecified = 3
    }
}
