using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Repositories.Base;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class GetWalkerByIdQueryHandler : IRequestHandler<GetWalkerByIdQuery, WalkerResponse?>
    {
        private readonly IRepository<Core.Entities.Walker> repository;

        public GetWalkerByIdQueryHandler(IRepository<Core.Entities.Walker> repository) => this.repository = repository;

        public async Task<WalkerResponse?> Handle(GetWalkerByIdQuery request, CancellationToken cancellationToken)
        {
            var walker = await repository.GetByIdAsync(request.Id);

            return walker == null ? null : WalkerMapper.Mapper.Map<WalkerResponse?>(walker);
        }
    }
}
