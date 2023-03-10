using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class DeleteWalkerQueryHandler : IRequestHandler<DeleteWalkerQuery>
    {
        private readonly IWalkerRepository _walkerRepository;

        public DeleteWalkerQueryHandler(IWalkerRepository walkerRepository)
            => _walkerRepository = walkerRepository;

        public async Task<Unit> Handle(DeleteWalkerQuery request, CancellationToken cancellationToken)
        {
            var walker = await _walkerRepository.GetByIdAsync(request.Id);
            await _walkerRepository.DeleteAsync(walker);
            return Unit.Value;
        }
    }
}
