namespace Dogo.Application.Response
{
    public class AddressResponse
    {
        public Guid Id { get; set; }
        public string? Street { get; set; }
        public string? City { get; set; }
        public string? State { get; set; }
        public string? ZipCode { get; set; }
        public float Latitude { get; set; }
        public float Longitude { get; set; }
        public string? AdditionalDetails { get; set; }
    }
}
