/**
 * The `ErrorResponseFactory` class is responsible for creating error responses based on exceptions.
 * It maps exception types to appropriate HTTP status codes and error messages.
 */
public class ErrorResponseFactory implements RestFramework.IErrorResponseFactory {
	private Map<String, Integer> httpStatusByErrorType = new Map<String, Integer>{
		RestFramework.InvalidUriException.class.getName() => RestFramework.HTTP_CODE_BAD_REQUEST,
		RestFramework.NotFoundException.class.getName() => RestFramework.HTTP_CODE_NOT_FOUND,
		RestFramework.MethodNotAllowedException.class.getName() => RestFramework.HTTP_CODE_METHOD_NOT_ALLOWED
	};

	/**
	 * Creates a new error response for the given exception.
	 *
	 * @param exc The exception for which to create an error response.
	 * @return An error response based on the exception.
	 */
	public RestFramework.IRestResponse newErrorRestResponse(Exception exc) {
		Integer statusCode = this.httpStatusByErrorType.get(exc.getTypeName());
		return statusCode != null
			? new ErrorResponse(statusCode, exc)
			: new ErrorResponse(
				RestFramework.HTTP_CODE_INTERNAL_SERVER_ERROR,
				RestFramework.ERROR_MESSAGE_INTERNAL_SERVER_ERROR,
				exc
			);
	}
}