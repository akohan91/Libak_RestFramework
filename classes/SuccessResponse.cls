/**
 * The `SuccessResponse` class represents a successful REST response. It allows developers to construct
 * responses with custom data, status codes, and headers.
 */
public virtual class SuccessResponse implements RestFramework.IRestResponse {
	protected Map<String, String> headers = new Map<String, String>();
	protected Integer statusCode;
	protected Blob data;

	/**
	 * Constructs a new `SuccessResponse` with the provided data as a `String`.
	 *
	 * @param data The data to include in the response.
	 */
		public SuccessResponse(String data) {
		this(RestFramework.HTTP_CODE_OK, Blob.valueOf(data));
	}

	/**
	 * Constructs a new `SuccessResponse` with the provided data as a `Blob`.
	 *
	 * @param data The data to include in the response.
	 */
	public SuccessResponse(Blob data) {
		this(RestFramework.HTTP_CODE_OK, data);
	}

	/**
	 * Constructs a new `SuccessResponse` with the specified status code and data as a `String`.
	 *
	 * @param statusCode The HTTP status code for the response.
	 * @param data       The data to include in the response.
	 */
	public SuccessResponse(Integer statusCode, String data) {
		this(statusCode, Blob.valueOf(data));
	}

	/**
	 * Constructs a new `SuccessResponse` with the specified status code and data as a `Blob`.
	 *
	 * @param statusCode The HTTP status code for the response.
	 * @param data       The data to include in the response.
	 */
	public SuccessResponse(Integer statusCode, Blob data) {
		this.setHttpStatusCode(statusCode);
		this.data = data;
	}

	/**
	 * Sets the HTTP status code for the response.
	 *
	 * @param statusCode The HTTP status code to set.
	 * @return The current `SuccessResponse` instance.
	 */
	public SuccessResponse setHttpStatusCode(Integer statusCode) {
		this.statusCode = statusCode;
		return this;
	}

	/**
	 * Adds a header to the response.
	 *
	 * @param key   The header key.
	 * @param value The header value.
	 * @return The current `SuccessResponse` instance.
	 */
	public SuccessResponse addHeader (String key, String value) {
		this.headers.put(key, value);
		return this;
	}

	/**
	 * Sends the success response with the configured status code, data, and headers.
	 * It sets the HTTP status code, response body, and headers in the RestContext's response object.
	 */
	public void sendResponse () {
		RestContext.response.statusCode = this.statusCode;
		if (this.data != null) {
			RestContext.response.responseBody = this.data;
		}
		if (!this.headers.isEmpty()) {
			for (String headerKey : this.headers.keySet()) {
				RestContext.response.addHeader(headerKey, this.headers.get(headerKey));
			}
		}
	}
}