using Dogo.Application.Commands.Address;
using Dogo.Application.Response;
using MediatR;

#nullable disable
namespace Dogo.Application.Commands.Walker
{
    public class CreateWalkerCommand : IRequest<WalkerResponse>
    {
        public string Id { get; set; }
    }
}
