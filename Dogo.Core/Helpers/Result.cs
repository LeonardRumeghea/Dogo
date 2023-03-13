namespace Dogo.Core.Helpers
{
    public class Result
    {
        public bool IsSuccess { get; set; }
        public bool IsFailure => !IsSuccess; // This is a read-only property
        public string? Message { get; set; }

        public HttpStatusCodeResponse httpStatusCode { get; set; }

        public static Result Success() => new() { IsSuccess = true };

        public static Result Failure(string message) => new() { IsSuccess = false, Message = message };
    }
}
