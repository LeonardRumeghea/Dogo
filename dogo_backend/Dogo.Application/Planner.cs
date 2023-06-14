using Dogo.Core.Entities;

namespace Dogo.Application
{
    public class Planner
    {
        static public List<Appointment> Plan(List<Appointment> appointments, UserPreferences userPreferences, DateTime startDate, DateTime endDate)
        {
            appointments = appointments.Where(a => a.DateWhen >= startDate && a.DateUntil <= endDate).ToList();

            appointments = appointments.OrderBy(a => a.DateWhen).ToList();

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

            // l    -----
            // c           -------

            return result;
        }
    }
}
