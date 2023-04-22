using AutoMapper;
using Dogo.Application.Commands.Review;
using Dogo.Application.Response;
using Dogo.Core.Entities;

namespace Dogo.Application.Mappers
{
    public class ReviewMapperProfile : Profile
    {
        public ReviewMapperProfile()
        {
            CreateMap<Review, ReviewResponse>().ReverseMap();
            CreateMap<Review, CreateReviewCommand>().ReverseMap();
        }
    }
}
