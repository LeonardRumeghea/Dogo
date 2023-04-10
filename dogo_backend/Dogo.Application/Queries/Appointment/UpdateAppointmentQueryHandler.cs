using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class UpdateAppointmentQueryHandler : IRequestHandler<UpdateAppointmentQuery, Result>
    {
        private readonly IUnitOfWork unitOfWork;

        public UpdateAppointmentQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<Result> Handle(UpdateAppointmentQuery request, CancellationToken cancellationToken)
        {
            var appointmentEntity = await unitOfWork.AppointmentRepository.GetByIdAsync(request.Id);
            if (appointmentEntity == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Appointment not found");
            }

            appointmentEntity.Date = DateTime.Parse(request.Appointment.Date);
            appointmentEntity.Notes = request.Appointment.Notes;
            appointmentEntity.PetId = request.Appointment.PetId;
            appointmentEntity.WalkerId = request.Appointment.WalkerId;

            await unitOfWork.AppointmentRepository.UpdateAsync(appointmentEntity);

            return Result.Success(HttpStatusCode.NoContent);
        }
    }
}
