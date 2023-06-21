namespace Dogo.Core.Entities
{
    public class Position
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
