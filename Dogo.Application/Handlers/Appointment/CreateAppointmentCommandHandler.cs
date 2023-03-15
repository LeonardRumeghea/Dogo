using Dogo.Application.Commands.Appointment;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Handlers.Appointment
{
    public class CreateAppointmentCommandHandler : IRequestHandler<CreateAppointmentCommand, ResultOfEntity<AppointmentResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public CreateAppointmentCommandHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<AppointmentResponse>> Handle(CreateAppointmentCommand request, CancellationToken cancellationToken)
        {
            var petEnity = await unitOfWork.PetRepository.GetByIdAsync(request.PetId);
            if (petEnity == null)
            {
                return ResultOfEntity<AppointmentResponse>.Failure(HttpStatusCode.NotFound, "Pet not found");
            }

            var walkerEntity = await unitOfWork.WalkerRepository.GetByIdAsync(request.WalkerId);
            if (walkerEntity == null)
            {
                return ResultOfEntity<AppointmentResponse>.Failure(HttpStatusCode.NotFound, "Walker not found");
            }

            var appointmentEntity = AppointmentMapper.Mapper.Map<Core.Enitities.Appointment>(request);

            await unitOfWork.AppointmentRepository.AddAsync(appointmentEntity);

            return ResultOfEntity<AppointmentResponse>.Success(
                HttpStatusCode.Created,
                AppointmentMapper.Mapper.Map<AppointmentResponse>(appointmentEntity)
            );
        }
    }
}
