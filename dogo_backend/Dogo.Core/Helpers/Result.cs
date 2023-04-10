namespace Dogo.Core.Helpers
{
    public class Result
    {
        public bool IsSuccess { get; set; }
        public bool IsFailure => !IsSuccess; // This is a read-only property
        public string? Message { get; set; }
        public HttpStatusCode StatusCode { get; set; }

        public HttpStatusCode httpStatusCode { get; set; }

        public static Result Success() => new() { IsSuccess = true };

        public static Result Success(HttpStatusCode statusCode) => new() { IsSuccess = true, StatusCode = statusCode };

        public static Result Failure(string message) => new() { IsSuccess = false, Message = message };

        public static Result Failure(HttpStatusCode statusCode, string message) 
            => new() { IsSuccess = false, Message = message, StatusCode = statusCode };
    }
}
