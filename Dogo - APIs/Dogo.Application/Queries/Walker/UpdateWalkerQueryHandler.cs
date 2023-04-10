using Dogo.Application.Mappers;
using Dogo.Core.Enitities;
using Dogo.Core.Helpers;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class UpdateWalkerQueryHandler : IRequestHandler<UpdateWalkerQuery, Result>
    {
        private readonly IUnitOfWork unitOfWork;

        public UpdateWalkerQueryHandler(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        public async Task<Result> Handle(UpdateWalkerQuery request, CancellationToken cancellationToken)
        {
            var walker = await unitOfWork.WalkerRepository.GetByIdAsync(request.WalkerId);

            if (walker == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Walker not found");
            }

            walker.FirstName = request.Walker.FirstName;
            walker.LastName = request.Walker.LastName;
            walker.Address = AddressMapper.Mapper.Map<Address>(request.Walker.Address);
            walker.PhoneNumber = request.Walker.PhoneNumber;
            walker.Email = request.Walker.Email;

            await unitOfWork.WalkerRepository.UpdateAsync(walker);

            return Result.Success(HttpStatusCode.NoContent);
        }
    }
}
