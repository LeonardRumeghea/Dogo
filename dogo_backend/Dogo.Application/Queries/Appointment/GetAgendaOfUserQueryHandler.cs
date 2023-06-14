using Dogo.Application.Response;
using Dogo.Core.Helpers;
using Dogo.Application.Mappers;
using MediatR;

namespace Dogo.Application.Queries.Appointment
{
    public class GetAgendaOfUserQueryHandler : IRequestHandler<GetAgendaOfUserQuery, ResultOfEntity<List<AppointmentResponse>>>
    {
        private readonly IUnitOfWork unitOfWork;

        public GetAgendaOfUserQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<ResultOfEntity<List<AppointmentResponse>>> Handle(GetAgendaOfUserQuery request, CancellationToken cancellationToken)
        {
            var user = await unitOfWork.UsersRepository.GetByIdAsync(request.UserId);
            if (user == null)
                return ResultOfEntity<List<AppointmentResponse>>.Failure(HttpStatusCode.NotFound, "User not found");

            var appointments = await unitOfWork.AppointmentRepository.GetAllAsync();

            var agenda = appointments
                .Where(x => x.WalkerId == request.UserId && x.Status == Core.Entities.AppointmentStatus.Assigned);

            var response = AppointmentMapper.Mapper.Map<List<AppointmentResponse>>(agenda);

            return ResultOfEntity<List<AppointmentResponse>>.Success(HttpStatusCode.OK, response);
        }
    }
}
