using Dogo.Core.Helpers;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class DeleteWalkerQueryHandler : IRequestHandler<DeleteWalkerQuery, Result>
    {
        private readonly IWalkerRepository _walkerRepository;

        public DeleteWalkerQueryHandler(IWalkerRepository walkerRepository)
            => _walkerRepository = walkerRepository;

        public async Task<Result> Handle(DeleteWalkerQuery request, CancellationToken cancellationToken)
        {
            var walker = await _walkerRepository.GetByIdAsync(request.Id);
            if (walker == null)
            {
                return Result.Failure(HttpStatusCode.NotFound, "Walker not found");
            }
            await _walkerRepository.DeleteAsync(walker);
            return Result.Success();
        }
    }
}
