using FluentValidation;

namespace Dogo.Application.Commands.Address
{
    public class CreateAddressCommandValidator : AbstractValidator<CreateAddressCommand>
    {
        public CreateAddressCommandValidator()
        {
            RuleFor(x => x.Street).NotEmpty().MaximumLength(100).WithMessage("Street is required");
            RuleFor(x => x.Number).NotEmpty().GreaterThan(0).WithMessage("Number is required");
            RuleFor(x => x.City).NotEmpty().MaximumLength(100).WithMessage("City is required");
            RuleFor(x => x.State).NotEmpty().MaximumLength(100).WithMessage("State is required");
            RuleFor(x => x.ZipCode).NotEmpty().MaximumLength(10).WithMessage("ZipCode is required");
        }
    }
}
