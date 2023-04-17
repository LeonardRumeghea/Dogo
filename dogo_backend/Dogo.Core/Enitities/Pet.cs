using Dogo.Core.Enums;
using Dogo.Core.Enums.Species;
using Dogo.Core.Helpers;

#nullable disable
namespace Dogo.Core.Enitities
{
    public class Pet
    {
        public Guid Id { get; set; }
        public Guid OwnerId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public Specie Specie { get; set; }
        public string Breed { get; set; }
        public DateTime DateOfBirth { get; set; }
        public PetGender Gender { get; set; }
        public List<Review> Reviews { get; set; }
        //public string Tags { get; set; }

        // Pet atributes

        public int totalNumberOfReviews { get; set; }
        public double Friendly { get; set; }
        public double Active { get; set; }
        public double Playful { get; set; }
        

        public double Rating() => Reviews == null || Reviews.Count == 0 ? 0 : Reviews.Average(r => r.Rating);

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