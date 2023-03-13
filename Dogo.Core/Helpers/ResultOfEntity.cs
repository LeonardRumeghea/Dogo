namespace Dogo.Core.Helpers
{
    public class ResultOfEntity <TEntity>
    {
        public bool IsSuccess { get; set; }
        public bool IsFailure => !IsSuccess; // This is a read-only property
        public string? Message { get; set; }
        public TEntity? Entity { get; set; }
        public HttpStatusCodeResponse httpStatusCode { get; set; }

        public static ResultOfEntity<TEntity> Success(TEntity entity) => new() { IsSuccess = true, Entity = entity };

        public static ResultOfEntity<TEntity> Success(HttpStatusCodeResponse code, TEntity entity) 
            => new() { IsSuccess = true, Entity = entity, httpStatusCode = code };

        public static ResultOfEntity<TEntity> Failure(string message) => new() { IsSuccess = false, Message = message };

        public static ResultOfEntity<TEntity> Failure(HttpStatusCodeResponse httpStatusCode, string message) 
            => new() { IsSuccess = false, Message = message, httpStatusCode = httpStatusCode };
    }
}
