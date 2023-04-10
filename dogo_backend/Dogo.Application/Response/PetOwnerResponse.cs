namespace Dogo.Application.Response
{
    public class PetOwnerResponse
    {
        public Guid Id { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? Password { get; set; }
        public string? PhoneNumber { get; set; }
        public AddressResponse? Address { get; set; }
    }
}
