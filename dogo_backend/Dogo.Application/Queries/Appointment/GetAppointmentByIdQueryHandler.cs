using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAppointmentByIdQueryHandler : IRequestHandler<GetAppointmentByIdQuery, ResultOfEntity<AppointmentResponse>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAppointmentByIdQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<AppointmentResponse>> Handle(GetAppointmentByIdQuery request, CancellationToken cancellationToken)
        {
            var appointment = await unitOfWork.AppointmentRepository.GetByIdAsync(request.Id);
            if (appointment == null)
            {
                return ResultOfEntity<AppointmentResponse>.Failure(HttpStatusCode.NotFound, "Appointment not found");
            }

            return ResultOfEntity<AppointmentResponse>.Success(
                HttpStatusCode.OK,
                AppointmentMapper.Mapper.Map<AppointmentResponse>(appointment)
            );
        }
    }
}
