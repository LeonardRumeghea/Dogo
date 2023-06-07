using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAppointmentsOfOwnerQueryHandler : IRequestHandler<GetAppointmentsOfOwnerQuery, ResultOfEntity<List<AppointmentResponse>>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAppointmentsOfOwnerQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<List<AppointmentResponse>>> Handle(GetAppointmentsOfOwnerQuery request, CancellationToken cancellationToken)
        {

            var owner = await unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (owner == null)
            {
                return ResultOfEntity<List<AppointmentResponse>>.Failure(HttpStatusCode.NotFound, "Owner not found");
            }

            var allAppoitments = await unitOfWork.AppointmentRepository.GetAllAsync();
            var userAppointments = new List<Core.Entities.Appointment>();

            foreach (var appointment in allAppoitments)
            {
                var pet = await unitOfWork.PetRepository.GetByIdAsync(appointment.PetId);
                if (pet.OwnerId == request.UserId)
                {
                    userAppointments.Add(appointment);
                }
            }

            var userAppointmentsResponse = AppointmentMapper.Mapper.Map<List<AppointmentResponse>>(userAppointments);

            return ResultOfEntity<List<AppointmentResponse>>.Success(HttpStatusCode.OK, userAppointmentsResponse);
        }
    }
}
