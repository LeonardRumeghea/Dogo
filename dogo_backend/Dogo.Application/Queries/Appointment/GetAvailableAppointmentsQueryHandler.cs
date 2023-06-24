using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAvailableAppointmentsQueryHandler : 
        IRequestHandler<GetAvailableAppointmentsQuery, ResultOfEntity<List<AppointmentResponse>>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public GetAvailableAppointmentsQueryHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<List<AppointmentResponse>>> Handle(GetAvailableAppointmentsQuery request, CancellationToken cancellationToken)
        {
            var user = _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
            {
                return ResultOfEntity<List<AppointmentResponse>>
                    .Failure(HttpStatusCode.NotFound, "User not found");
            }

            var userPetsId = user.Result.Pets.Select(x => x.Id);
            
            var appointments = await _unitOfWork.AppointmentRepository.GetAllAsync();
            if (appointments == null)
            {
                return ResultOfEntity<List<AppointmentResponse>>
                    .Failure(HttpStatusCode.NotFound, "No appointments found");
            }

            var availableAppointments = appointments
                .Where(x => !userPetsId.Contains(x.PetId))
                .Where(x => x.Status == Core.Entities.AppointmentStatus.Pending);
            
            if (availableAppointments == null)
            {
                return ResultOfEntity<List<AppointmentResponse>>
                    .Failure(HttpStatusCode.NotFound, "No available appointments found");
            }

            var userPreferences = await _unitOfWork.UserPreferencesRepository.getByUserId(request.UserId);
            availableAppointments = (new Planner(_unitOfWork)).SortByPreferencesAndDateWhen(availableAppointments.ToList(), userPreferences);

            //var startDate = DateTime.Parse("2023-06-26 08:00:00.000");
            //var endDate = DateTime.Parse("2023-06-26 20:00:00.000");
            //var travelMode = "walking";

            //availableAppointments = (new Planner(_unitOfWork)).Plan(availableAppointments.ToList(), userPreferences, startDate, endDate, travelMode);
            //availableAppointments = availableAppointments.Take(request.NumberOfAppoitments);

            var availableAppointmentsResponse = AppointmentMapper.Mapper.Map<List<AppointmentResponse>>(availableAppointments);

            return ResultOfEntity<List<AppointmentResponse>>.Success(HttpStatusCode.OK, availableAppointmentsResponse);
        }
    }
}
