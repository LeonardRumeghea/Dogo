using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetPlanForUserQueryHandler : IRequestHandler<GetPlanForUserQuery, ResultOfEntity<List<AppointmentResponse>>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public GetPlanForUserQueryHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<List<AppointmentResponse>>> Handle(GetPlanForUserQuery request, CancellationToken cancellationToken)
        {
            var user = _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
            {
                return ResultOfEntity<List<AppointmentResponse>>.Failure(HttpStatusCode.NotFound, "User not found");
            }

            var userPetsId = user.Result.Pets.Select(x => x.Id);

            var appointments = await _unitOfWork.AppointmentRepository.GetAllAsync();
            if (appointments == null)
            {
                return ResultOfEntity<List<AppointmentResponse>>.Failure(HttpStatusCode.NotFound, "No appointments found");
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
            availableAppointments = (new Planner(_unitOfWork)).Plan(availableAppointments.ToList(), userPreferences, request.StartDate, request.EndDate, request.TravelMode);
            availableAppointments = availableAppointments.Take(request.NumberOfAppointments);

            var availableAppointmentsResponse = AppointmentMapper.Mapper.Map<List<AppointmentResponse>>(availableAppointments);

            return ResultOfEntity<List<AppointmentResponse>>.Success(HttpStatusCode.OK, availableAppointmentsResponse);
        }
    }
}
