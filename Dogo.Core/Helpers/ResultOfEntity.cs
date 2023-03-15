namespace Dogo.Core.Helpers
{
    public class ResultOfEntity <TEntity>
    {
        public bool IsSuccess { get; set; }
        public bool IsFailure => !IsSuccess; // This is a read-only property
        public string? Message { get; set; }
        public TEntity? Entity { get; set; }
        public HttpStatusCode StatusCode { get; set; }

        public static ResultOfEntity<TEntity> Success(TEntity entity) => new() { IsSuccess = true, Entity = entity };

        public static ResultOfEntity<TEntity> Success(HttpStatusCode code, TEntity entity) 
            => new() { IsSuccess = true, Entity = entity, StatusCode = code };

        public static ResultOfEntity<TEntity> Failure(string message) => new() { IsSuccess = false, Message = message };

        public static ResultOfEntity<TEntity> Failure(HttpStatusCode httpStatusCode, string message) 
            => new() { IsSuccess = false, Message = message, StatusCode = httpStatusCode };
    }
}
