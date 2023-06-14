using Dogo.Core.Entities;
using Dogo.Core.Enums.Species;

namespace Dogo.Application
{
    public class Planner
    {
        private readonly IUnitOfWork _unitOfWork;

        public Planner(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public List<Appointment> Plan(List<Appointment> appointments, UserPreferences userPreferences, DateTime startDate, DateTime endDate)
        {
            appointments = appointments.Where(a => a.DateWhen >= startDate && a.DateUntil <= endDate).ToList();

            appointments = appointments.OrderBy(a => PointsOfAppointment(a, userPreferences)).ThenBy(a => a.DateWhen).ToList();

            var result = new List<Appointment>();
            var lastAppointment = appointments[0];

            for (int i = 1; i < appointments.Count; i++)
            {
                var currentAppointment = appointments[i];

                if (currentAppointment.DateWhen < lastAppointment.DateUntil)
                {
                    if (currentAppointment.DateUntil > lastAppointment.DateUntil)
                    {
                        lastAppointment.DateUntil = currentAppointment.DateUntil;
                    }
                }
                else
                {
                    result.Add(lastAppointment);
                    lastAppointment = currentAppointment;
                }
            }

            result.Add(lastAppointment);
            
            return result;
        }

        public List<Appointment> SortByPreferencesAndDateWhen(List<Appointment> appointments, UserPreferences preferences)
            => appointments.OrderBy(a => PointsOfAppointment(a, preferences)).ThenBy(a => a.DateWhen).ToList();

        private int PointsOfAppointment(Appointment appointment, UserPreferences apppointmentPreferences) 
            => PointsOfActivity(appointment.Type, apppointmentPreferences) + PointsOfPet(appointment.PetId, apppointmentPreferences);

        private static int PointsOfActivity(AppointmentType appointmentType, UserPreferences userPreferences)
        {
            return appointmentType switch 
            {
                AppointmentType.Walk => (int)userPreferences.WalkPreference,
                AppointmentType.Vet => (int)userPreferences.VetPreference,
                AppointmentType.Salon => (int)userPreferences.SalonPreference,
                AppointmentType.Sitting => (int)userPreferences.SitPreference,
                AppointmentType.Shopping => (int)userPreferences.ShoppingPreference,
                _ => 0
            };
        }
        
        private int PointsOfPet(Guid petId, UserPreferences userPreferences)
        {
            var pet = _unitOfWork.PetRepository.GetByIdAsync(petId).Result;

            return pet.Specie switch
            {
                Specie.Dog => (int)userPreferences.DogPreference,
                Specie.Cat => (int)userPreferences.CatPreference,
                Specie.Rabbit => (int)userPreferences.RabbitPreference,
                Specie.Bird => (int)userPreferences.BirdPreference,
                Specie.Fish => (int)userPreferences.FishPreference,
                Specie.Ferret => (int)userPreferences.FerretPreference,
                Specie.GuineaPig => (int)userPreferences.GuineaPigPreference,
                Specie.Other => (int)userPreferences.OtherPreference,
                _ => 0
            };
        }
    }
}
