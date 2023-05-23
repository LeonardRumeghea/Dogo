using Dogo.Core.Helpers;

#nullable disable
namespace Dogo.Core.Entities
{
    public class User
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string PhoneNumber { get; set; }
        public Address Address { get; set; }
        public List<Pet> Pets { get; set; } = new List<Pet>();

        public ResultOfEntity<Pet> RegisterPet(Pet pet)
        {
            try
            {
                Pets ??= new List<Pet>();
                Pets.Add(pet);
                var result = pet.RegisterToOwner(this.Id);

                return result.IsSuccess 
                    ? ResultOfEntity<Pet>.Success(result.Entity) 
                    : ResultOfEntity<Pet>.Failure(result.Message);
            }
            catch (Exception ex)
            {
                return ResultOfEntity<Pet>.Failure(ex.Message);
            }
        } 

        public Result RemovePet(Pet pet)
        {
            try
            {
                Pets ??= new List<Pet>();
                if (Pets.Contains(pet))
                {
                    Pets.Remove(pet);
                    return Result.Success();
                }

                return Result.Failure("Pet not found");
            }
            catch (Exception ex)
            {
                return Result.Failure(ex.Message);
            }
        }
    }
}
