using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class InProgressAppointmentQueryHandler : IRequestHandler<InProgressAppointmentQuery, Result>
    {
        private readonly IUnitOfWork _unitOfWork;

        public InProgressAppointmentQueryHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

        public async Task<Result> Handle(InProgressAppointmentQuery request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.UsersRepository.GetByIdAsync(request.UserId);

            if (user is null)
                return Result.Failure(HttpStatusCode.NotFound, "User not found");

            var appointment = await _unitOfWork.AppointmentRepository.GetByIdAsync(request.AppointmentId);

            if (appointment is null)
                return Result.Failure(HttpStatusCode.NotFound, "Appointment not found");

            if (appointment.WalkerId != user.Id)
                return Result.Failure(HttpStatusCode.Forbidden, "You are not the walker of this appointment");

            appointment.Status = Core.Entities.AppointmentStatus.InProgress;

            await _unitOfWork.AppointmentRepository.UpdateAsync(appointment);

            return Result.Success(HttpStatusCode.OK);
        }
    }
}
