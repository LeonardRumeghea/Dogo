using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAvailableAppointmentsQueryHandler : 
        IRequestHandler<GetAvailableAppointmentsQuery, ResultOfEntity<List<AppointmentResponse>>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAvailableAppointmentsQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<List<AppointmentResponse>>> Handle(GetAvailableAppointmentsQuery request, CancellationToken cancellationToken)
        {
            var user = unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
            {
                return ResultOfEntity<List<AppointmentResponse>>
                    .Failure(HttpStatusCode.NotFound, "User not found");
            }

            var userPetsId = user.Result.Pets.Select(x => x.Id);
            
            var appointments = await unitOfWork.AppointmentRepository.GetAllAsync();
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

            var availableAppointmentsResponse = AppointmentMapper.Mapper.Map<List<AppointmentResponse>>(availableAppointments);

            return ResultOfEntity<List<AppointmentResponse>>.Success(HttpStatusCode.OK, availableAppointmentsResponse);
        }
    }
}
