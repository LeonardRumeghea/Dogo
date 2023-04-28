using Dogo.Application.Response;
using Dogo.Core.Entities;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class AssignAppointmentQueryHandler : IRequestHandler<AssignAppointmentQuery, Result>
    {
        private readonly IUnitOfWork unitOfWork;

        public AssignAppointmentQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<Result> Handle(AssignAppointmentQuery request, CancellationToken cancellationToken)
        {
            var appointment = await unitOfWork.AppointmentRepository.GetByIdAsync(request.AppointmentId);
            if (appointment == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Appointment not found");
            }

            var user = await unitOfWork.PetOwnerRepository.GetByIdAsync(request.UserId);
            if (user == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "User not found");
            }

            appointment.WalkerId = request.UserId;
            appointment.Status = AppointmentStatus.Assigned;

            await unitOfWork.AppointmentRepository.UpdateAsync(appointment);

            return Result.Success(HttpStatusCode.NoContent);
        }
    }
}
