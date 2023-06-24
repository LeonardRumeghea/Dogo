using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using Dogo.Core.Enums.Species;
using Newtonsoft.Json.Linq;

#nullable disable
namespace Dogo.Application
{
    public class Planner
    {
        private readonly IUnitOfWork _unitOfWork;

        public Planner(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public List<Appointment> Plan(List<Appointment> appointments, UserPreferences userPreferences, DateTime startDate, DateTime endDate, String travelMode = "walking")
        {
            appointments = appointments.Where(a => a.DateWhen >= startDate && a.DateUntil <= endDate).ToList();

            //appointments = appointments.OrderBy(a => PointsOfAppointment(a, userPreferences)).ThenBy(a => a.DateWhen).ToList();
            appointments = SortByPreferencesAndDateWhen(appointments, userPreferences);

            for (int idx = 0; idx < appointments.Count; idx++)
            {
                if (appointments[idx].Type == AppointmentType.Salon || appointments[idx].Type == AppointmentType.Vet)
                {
                    var appointmentEndDate = appointments[idx].DateUntil;
                    var pet = _unitOfWork.PetRepository.GetByIdAsync(appointments[idx].PetId).Result;
                    var owner = _unitOfWork.UsersRepository.GetByIdAsync(pet.OwnerId).Result;

                    var travelTime = GetTravelTime(appointments[idx].Address.Latitude, appointments[idx].Address.Longitude, owner.Address.Latitude, owner.Address.Longitude, travelMode);
                    appointments[idx].DateUntil = appointments[idx].DateUntil.AddSeconds(travelTime.Result);
                }
            }

            var selectedAppointments = new List<Appointment> { appointments[0] };
            for (int idx = 1; idx < appointments.Count; idx++) 
            {
                if (appointments[idx].DateUntil <= selectedAppointments[0].DateUntil)
                {
                    if (CanTravel(appointments[idx], selectedAppointments[0], travelMode))
                    {
                        selectedAppointments.Insert(0, appointments[idx]);
                        continue;
                    }
                }

                if (appointments[idx].DateWhen >= selectedAppointments[^1].DateUntil)
                {
                    if (CanTravel(selectedAppointments[^1], appointments[idx], travelMode))
                    {
                        selectedAppointments.Add(appointments[idx]);
                        continue;
                    }
                }

                for (int sIdx = 0; sIdx < selectedAppointments.Count - 1; sIdx++)
                {
                    if (appointments[idx].DateWhen >= selectedAppointments[sIdx].DateUntil && appointments[idx].DateUntil <= selectedAppointments[sIdx + 1].DateWhen)
                    {
                        if (CanTravel(selectedAppointments[sIdx], appointments[idx], travelMode) && CanTravel(appointments[idx], selectedAppointments[sIdx + 1], travelMode))
                        {
                            selectedAppointments.Insert(sIdx + 1, appointments[idx]);
                            break;
                        }
                    }
                }
            }

            return selectedAppointments;

        }

        bool CanTravel(Appointment fromAppointment, Appointment toAppointment, string travelMode)
        {
            var petFrom = _unitOfWork.PetRepository.GetByIdAsync(fromAppointment.PetId).Result;
            var ownerFrom = _unitOfWork.UsersRepository.GetByIdAsync(petFrom.OwnerId).Result;

            var petTo = _unitOfWork.PetRepository.GetByIdAsync(toAppointment.PetId).Result;
            var ownerTo = _unitOfWork.UsersRepository.GetByIdAsync(petTo.OwnerId).Result;

            var travelTime = GetTravelTime(ownerFrom.Address.Latitude, ownerFrom.Address.Longitude, ownerTo.Address.Latitude, ownerTo.Address.Longitude, travelMode);

            return fromAppointment.DateUntil.AddSeconds(travelTime.Result) <= toAppointment.DateWhen;
        }

        static async Task<int> GetTravelTime(double fromLat, double fromLong, double toLat, double toLong, string travelMode)
        {
            HttpClient client = new();

            string base_Url = "https://maps.googleapis.com/maps/api/distancematrix/json?";
            string mode = "mode=" + travelMode;
            string units = "units=metric";
            string apiKey = $"key={Config.GOOGLE_APY_KEY}";

            var URL = $"{base_Url}origins={fromLat},{fromLong}&destinations={toLat},{toLong}&{mode}&{units}&{apiKey}";
            var responseContent = await (await client.GetAsync(URL)).Content.ReadAsStringAsync();
            return (int)JObject.Parse(responseContent)["rows"][0]["elements"][0]["duration"]["value"];
        }

        public List<Appointment> SortByPreferencesAndDateWhen(List<Appointment> appointments, UserPreferences preferences)
            => appointments.OrderByDescending(a => PointsOfAppointment(a, preferences)).ThenBy(a => a.DateWhen).ToList();

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
