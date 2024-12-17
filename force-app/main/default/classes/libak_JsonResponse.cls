/**
* The `libak_JsonResponse` class represents a successful REST response with JSON data. It extends the `libak_SuccessResponse`
* class and provides convenience methods for handling JSON data.
*/
public class libak_JsonResponse extends libak_SuccessResponse {

	/**
	 * Constructs a new `libak_JsonResponse` with the provided JSON data as a string.
	 *
	 * @param data The JSON data to include in the response.
	 */
	public libak_JsonResponse(String data) {
		super(data);
		this.addHeader(libak_RestFramework.HEADER_NAME_CONTENT_TYPE, libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}

	/**
	 * Constructs a new `libak_JsonResponse` with the provided JSON data as an object, serialized to a string.
	 *
	 * @param data The JSON data to include in the response.
	 */
	public libak_JsonResponse(Object data) {
		super(Blob.valueOf(JSON.serialize(data)));
		this.addHeader(libak_RestFramework.HEADER_NAME_CONTENT_TYPE, libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}

	/**
	 * Constructs a new `libak_JsonResponse` with the specified status code and JSON data as a string.
	 *
	 * @param statusCode The HTTP status code for the response.
	 * @param data       The JSON data to include in the response.
	 */
	public libak_JsonResponse(Integer statusCode, String data) {
		super(statusCode, data);
		this.addHeader(libak_RestFramework.HEADER_NAME_CONTENT_TYPE, libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}

	/**
	 * Constructs a new `libak_JsonResponse` with the specified status code and JSON data as an object, serialized to a string.
	 *
	 * @param statusCode The HTTP status code for the response.
	 * @param data       The JSON data to include in the response.
	 */
	public libak_JsonResponse(Integer statusCode, Object data) {
		super(statusCode, Blob.valueOf(JSON.serialize(data)));
		this.addHeader(libak_RestFramework.HEADER_NAME_CONTENT_TYPE, libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}
}
