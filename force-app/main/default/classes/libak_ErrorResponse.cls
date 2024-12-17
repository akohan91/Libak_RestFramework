/**
 * The `libak_ErrorResponse` class represents an error REST response. It allows developers to construct
 * responses with custom error messages, status codes, and details.
 */
public class libak_ErrorResponse implements libak_RestFramework.IRestResponse {
	@TestVisible
	private Integer statusCode;
	@TestVisible
	private String summary;
	private String details;

	/**
	 * Constructs a new `libak_ErrorResponse` with the specified status code, summary, and details.
	 *
	 * @param statusCode The HTTP status code for the error response.
	 * @param summary    A summary message describing the error.
	 * @param details    Additional details about the error.
	 */
	public libak_ErrorResponse(Integer statusCode, String summary, String details) {
		this.statusCode = statusCode;
		this.summary = summary;
		this.details = details;
	}

	/**
	 * Constructs a new `libak_ErrorResponse` with the specified status code and summary,
	 * based on an exception.
	 *
	 * @param status The HTTP status code for the error response.
	 * @param summary A summary message describing the error.
	 * @param exc     The exception from which to derive error details.
	 */
	public libak_ErrorResponse(Integer status, String summary, Exception exc) {
		this(status, summary, exc?.getMessage());
	}

	/**
	 * Constructs a new `libak_ErrorResponse` based on an exception. It sets the status code,
	 * summary, and details based on the exception's information.
	 *
	 * @param status The HTTP status code for the error response.
	 * @param exc    The exception from which to derive error details.
	 */
	public libak_ErrorResponse(Integer status, Exception exc) {
		this(status, exc?.getMessage(), exc);
	}

	/**
	 * Sends the error response with the configured status code, summary, and details.
	 * It sets the HTTP status code, response body (serialized error information in JSON format),
	 * and content type header in the RestContext's response object.
	 */
	public void sendResponse() {
		RestContext.response.statusCode = this.statusCode;
		RestContext.response.responseBody = BLOB.valueOf(JSON.serialize(this));
		RestContext.response.addHeader(libak_RestFramework.HEADER_NAME_CONTENT_TYPE, libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}
}