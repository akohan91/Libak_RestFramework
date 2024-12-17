/**
 * The `libak_ErrorResponseFactory` class is responsible for creating error responses based on exceptions.
 * It maps exception types to appropriate HTTP status codes and error messages.
 */
public class libak_ErrorResponseFactory implements libak_RestFramework.IErrorResponseFactory {
	private Map<String, Integer> httpStatusByErrorType = new Map<String, Integer>{
		libak_RestFramework.InvalidUriException.class.getName() => libak_RestFramework.HTTP_CODE_BAD_REQUEST,
		libak_RestFramework.NotFoundException.class.getName() => libak_RestFramework.HTTP_CODE_NOT_FOUND,
		libak_RestFramework.MethodNotAllowedException.class.getName() => libak_RestFramework.HTTP_CODE_METHOD_NOT_ALLOWED
	};

	/**
	 * Creates a new error response for the given exception.
	 *
	 * @param exc The exception for which to create an error response.
	 * @return An error response based on the exception.
	 */
	public libak_RestFramework.IRestResponse newErrorRestResponse(Exception exc) {
		Integer statusCode = this.httpStatusByErrorType.get(exc.getTypeName());
		return statusCode != null
			? new libak_ErrorResponse(statusCode, exc)
			: new libak_ErrorResponse(
				libak_RestFramework.HTTP_CODE_INTERNAL_SERVER_ERROR,
				libak_RestFramework.ERROR_MESSAGE_INTERNAL_SERVER_ERROR,
				exc
			);
	}
}