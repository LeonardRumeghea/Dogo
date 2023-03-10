using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Repositories;
using MediatR;

namespace Dogo.Application.Queries.Walker
{
    public class GetAllWalkersQueryHandler : IRequestHandler<GetAllWalkersQuery, List<WalkerResponse>>
    {
        private readonly IWalkerRepository _walkerRepository;

        public GetAllWalkersQueryHandler(IWalkerRepository walkerRepository)
            => _walkerRepository = walkerRepository;

        public async Task<List<WalkerResponse>> Handle(GetAllWalkersQuery request, CancellationToken cancellationToken)
        {
            var walkers = await _walkerRepository.GetAllAsync();
            return WalkerMapper.Mapper.Map<List<WalkerResponse>>(walkers);
        }
    }
}
