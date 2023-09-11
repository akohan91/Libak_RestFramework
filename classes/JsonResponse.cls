/**
* The `JsonResponse` class represents a successful REST response with JSON data. It extends the `SuccessResponse`
* class and provides convenience methods for handling JSON data.
*/
public class JsonResponse extends SuccessResponse {

	/**
	 * Constructs a new `JsonResponse` with the provided JSON data as a string.
	 *
	 * @param data The JSON data to include in the response.
	 */
	public JsonResponse(String data) {
		super(data);
		this.addHeader(RestFramework.HEADER_NAME_CONTENT_TYPE, RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}

	/**
	 * Constructs a new `JsonResponse` with the provided JSON data as an object, serialized to a string.
	 *
	 * @param data The JSON data to include in the response.
	 */
	public JsonResponse(Object data) {
		super(Blob.valueOf(JSON.serialize(data)));
		this.addHeader(RestFramework.HEADER_NAME_CONTENT_TYPE, RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}

	/**
	 * Constructs a new `JsonResponse` with the specified status code and JSON data as a string.
	 *
	 * @param statusCode The HTTP status code for the response.
	 * @param data       The JSON data to include in the response.
	 */
	public JsonResponse(Integer statusCode, String data) {
		super(statusCode, data);
		this.addHeader(RestFramework.HEADER_NAME_CONTENT_TYPE, RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}

	/**
	 * Constructs a new `JsonResponse` with the specified status code and JSON data as an object, serialized to a string.
	 *
	 * @param statusCode The HTTP status code for the response.
	 * @param data       The JSON data to include in the response.
	 */
	public JsonResponse(Integer statusCode, Object data) {
		super(statusCode, Blob.valueOf(JSON.serialize(data)));
		this.addHeader(RestFramework.HEADER_NAME_CONTENT_TYPE, RestFramework.CONTENT_TYPE_APPLICATION_JSON);
	}
}
