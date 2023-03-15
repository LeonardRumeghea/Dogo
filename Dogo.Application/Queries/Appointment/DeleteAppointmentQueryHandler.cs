using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class DeleteAppointmentQueryHandler : IRequestHandler<DeleteAppointmentQuery, Result>
    {
        private readonly IUnitOfWork unitOfWork;

        public DeleteAppointmentQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<Result> Handle(DeleteAppointmentQuery request, CancellationToken cancellationToken)
        {
            var appointmentEntity = await unitOfWork.AppointmentRepository.GetByIdAsync(request.Id);
            if (appointmentEntity == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Appointment not found");
            }

            await unitOfWork.AppointmentRepository.DeleteAsync(appointmentEntity);

            return Result.Success(HttpStatusCode.NoContent);
        }
    }
}
