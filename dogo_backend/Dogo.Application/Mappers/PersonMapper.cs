using AutoMapper;

namespace Dogo.Application.Mappers
{
    public class PersonMapper
    {
        private static readonly Lazy<IMapper> Lazy =
            new(() =>
            {
                var config = new MapperConfiguration(cfg =>
                {
                    cfg.ShouldMapProperty = p => p.GetMethod.IsPublic || p.GetMethod.IsAssembly;
                    cfg.AddProfile<PersonMapperProfile>();
                    cfg.AddProfile<AddressMapperProfile>();
                });
                var mapper = config.CreateMapper();
                return mapper;
            });
        public static IMapper Mapper => Lazy.Value;
    }
}
