using Dogo.Application.Commands.Walker;
using Dogo.Application.Mappers;
using Dogo.Application.Response;
using Dogo.Core.Repositories.Base;
using MediatR;

namespace Dogo.Application.Handlers.Walker
{
    public class CreateWalkerCommandHandler : IRequestHandler<CreateWalkerCommand, WalkerResponse>
    {
        private readonly IRepository<Core.Enitities.Walker> repository;
        public CreateWalkerCommandHandler(IRepository<Core.Enitities.Walker> repository) => this.repository = repository;

        public async Task<WalkerResponse> Handle(CreateWalkerCommand request, CancellationToken cancellationToken)
        {
            var walkerEntity = WalkerMapper.Mapper.Map<Core.Enitities.Walker>(request);
            if (walkerEntity == null)
            {
                throw new ApplicationException("Issue with the mapper");
            }

            var newWalker = await repository.AddAsync(walkerEntity);
            return WalkerMapper.Mapper.Map<WalkerResponse>(newWalker);
        }
    }
}
