using Dogo.Core.Entities;
using Dogo.Core.Repositories;
using Dogo.Infrastructure.Data;
using Dogo.Infrastructure.Repositories.Base;

namespace Dogo.Infrastructure.Repositories
{
    public class ReviewRepository : Repository<Review>, IReviewRepository
    {
        public ReviewRepository(DatabaseContext context) : base(context) { }
    }
}
