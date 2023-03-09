using AutoMapper;

#nullable disable
namespace Dogo.Application.Mappers
{
    public static class PetMapper
    {
        private static readonly Lazy<IMapper> Lazy =
           new(() =>
           {
               var config = new MapperConfiguration(cfg =>
               {
                   cfg.ShouldMapProperty = p => p.GetMethod.IsPublic || p.GetMethod.IsAssembly;
                   cfg.AddProfile<PetMapperProfile>();
               });
               var mapper = config.CreateMapper();
               return mapper;
           });
        public static IMapper Mapper => Lazy.Value;
    }
}
