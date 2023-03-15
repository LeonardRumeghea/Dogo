using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAllAppointmentsQueryHandler : IRequestHandler<GetAllAppointmentsQuery, ResultOfEntity<List<AppointmentResponse>>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAllAppointmentsQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<List<AppointmentResponse>>> Handle(GetAllAppointmentsQuery request, CancellationToken cancellationToken)
        {
            var appointments = await unitOfWork.AppointmentRepository.GetAllAsync();

            return ResultOfEntity<List<AppointmentResponse>>.Success(
                HttpStatusCode.OK,
                AppointmentMapper.Mapper.Map<List<AppointmentResponse>>(appointments)
            );
        }
    }
}
