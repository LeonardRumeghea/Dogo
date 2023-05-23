using Dogo.Core.Enums;
using Dogo.Core.Enums.Species;
using Dogo.Core.Helpers;

#nullable disable
namespace Dogo.Core.Entities
{
    public class Pet
    {
        public Guid Id { get; set; }
        public Guid OwnerId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public Specie Specie { get; set; }
        public string Breed { get; set; }
        public DateTime DateOfBirth { get; set; }
        public PetGender Gender { get; set; }

        public double Age() => DateTime.Now.Subtract(DateOfBirth).TotalDays / 365;

        public ResultOfEntity<Pet> RegisterToOwner(Guid petOwnerid)
        {
            try
            {
                OwnerId = petOwnerid;
                return ResultOfEntity<Pet>.Success(this);
            }
            catch (Exception ex)
            {
                return ResultOfEntity<Pet>.Failure(ex.Message);
            }
        }
    }
}