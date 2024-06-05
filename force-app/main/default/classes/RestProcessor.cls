/**
 * The `RestProcessor` class serves as the base class for implementing specific REST processors.
 * It includes methods for handling different HTTP methods, parsing URI parameters, and managing errors.
 * @return   {RestFramework.IRestResponse}
 */
public virtual class RestProcessor {
	@TestVisible
	protected RestRequest request;
	@TestVisible
	private String uriTemplate;
	@TestVisible
	private Map<String, String> uriParamsMap;
	@TestVisible
	private RestFramework.IErrorResponseFactory errorResponseFactory;
	@TestVisible
	private RestFramework.IRestLogger restLogger;

	/**
	 * Processes the incoming REST request by handling different HTTP methods and managing errors.
	 *
	 * This method is the entry point for processing incoming REST requests. It dynamically dispatches the request
	 * to the appropriate handler based on the HTTP method (GET, POST, PUT, PATCH, DELETE). If an unsupported
	 * HTTP method is received, it throws a RestFramework.MethodNotAllowedException.
	 *
	 * @return An instance of RestFramework.IRestResponse representing the response to the REST request.
	 * @throws RestFramework.MethodNotAllowedException If the incoming HTTP method is not supported for this resource.
	 */
	public RestFramework.IRestResponse process() {
		try {
			switch on(String) this.request.httpMethod {
				when 'GET' {
					return handleGet();
				}
				when 'POST' {
					return handlePost();
				}
				when 'PUT' {
					return handlePut();
				}
				when 'PATCH' {
					return handlePatch();
				}
				when 'DELETE' {
					return handleDelete();
				} when else {
					this.throwMethodNotAllowedException();
					return null;
				}
			}
		} catch (Exception exc) {
			this.restLogger?.addErrorDetails(exc);
			return this.errorResponseFactory.newErrorRestResponse(exc);
		}
	}

	/**
	 * Sets the URI template for this `RestProcessor`. The URI template defines the expected structure
	 * of the incoming URI, including any URI parameters.
	 *
	 * @param uriTemplate The URI template to set, in the format "/service/resource/:paramName".
	 *                    The colon (:) is used to denote URI parameters, and the parameter name is
	 *                    used as the key for mapping URI values.
	 * @return The current `RestProcessor` instance with the URI template set.
	 */
	public RestProcessor useUriTemplate(String uriTemplate) {
		this.uriTemplate = uriTemplate;
		return this;
	}

	/**
	 * Sets the REST request for this `RestProcessor`. The REST request contains information about the incoming
	 * HTTP request, including the HTTP method, headers, and request parameters.
	 *
	 * @param request The `RestRequest` object representing the incoming HTTP request.
	 * @return The current `RestProcessor` instance with the specified REST request set.
	 */
	public RestProcessor useRestRequest(RestRequest request) {
		this.request = request;
		return this;
	}

	/**
	 * Sets the error response factory for this `RestProcessor`.
	 *
	 * @param errorResponseFactory The error response factory to use.
	 * @return The current `RestProcessor` instance.
	 */
	public RestProcessor useErrorResponseFactory(RestFramework.IErrorResponseFactory errorResponseFactory) {
		this.errorResponseFactory = errorResponseFactory;
		return this;
	}

	/**
	 * Sets the REST logger for this `RestProcessor`.
	 *
	 * @param restLogger The REST logger to use.
	 * @return The current `RestProcessor` instance.
	 */
	public RestProcessor useRestLogger(RestFramework.IRestLogger restLogger) {
		this.restLogger = restLogger;
		return this;
	}

	/* VIRTUAL METHODS */

	/**
	 * Handles the HTTP GET method for processing REST requests. Override this method in a subclass to implement
	 * custom GET request handling logic.
	 *
	 * If this method is called without being overridden in a subclass, it will throw a RestFramework.MethodNotAllowedException
	 * indicating that the GET method is not supported for this resource.
	 *
	 * @return An instance of RestFramework.IRestResponse representing the response to the GET request.
	 */
	protected virtual RestFramework.IRestResponse handleGet() {
		this.throwMethodNotAllowedException();
		return null;
	}

	/**
	 * Handles the HTTP POST method for processing REST requests. Override this method in a subclass to implement
	 * custom POST request handling logic.
	 *
	 * If this method is called without being overridden in a subclass, it will throw a RestFramework.MethodNotAllowedException
	 * indicating that the POST method is not supported for this resource.
	 *
	 * @return An instance of RestFramework.IRestResponse representing the response to the POST request.
	 */
	protected virtual RestFramework.IRestResponse handlePost() {
		this.throwMethodNotAllowedException();
		return null;
	}

	/**
	 * Handles the HTTP PUT method for processing REST requests. Override this method in a subclass to implement
	 * custom PUT request handling logic.
	 *
	 * If this method is called without being overridden in a subclass, it will throw a RestFramework.MethodNotAllowedException
	 * indicating that the PUT method is not supported for this resource.
	 *
	 * @return An instance of RestFramework.IRestResponse representing the response to the PUT request.
	 */
	protected virtual RestFramework.IRestResponse handlePut() {
		this.throwMethodNotAllowedException();
		return null;
	}

	/**
	 * Handles the HTTP PATCH method for processing REST requests. Override this method in a subclass to implement
	 * custom PATCH request handling logic.
	 *
	 * If this method is called without being overridden in a subclass, it will throw a RestFramework.MethodNotAllowedException
	 * indicating that the PATCH method is not supported for this resource.
	 *
	 * @return An instance of RestFramework.IRestResponse representing the response to the PATCH request.
	 */
	protected virtual RestFramework.IRestResponse handlePatch() {
		this.throwMethodNotAllowedException();
		return null;
	}

	/**
	 * Handles the HTTP DELETE method for processing REST requests. Override this method in a subclass to implement
	 * custom DELETE request handling logic.
	 *
	 * If this method is called without being overridden in a subclass, it will throw a RestFramework.MethodNotAllowedException
	 * indicating that the DELETE method is not supported for this resource.
	 *
	 * @return An instance of RestFramework.IRestResponse representing the response to the DELETE request.
	 */
	protected virtual RestFramework.IRestResponse handleDelete() {
		this.throwMethodNotAllowedException();
		return null;
	}


	/* PRIVATE METHODS */

	/**
	 * Retrieves the value of a URI parameter by its name. URI parameters are placeholders
	 * in the URI template specified when configuring the `RestProcessor`.
	 *
	 * @param paramName The name of the URI parameter to retrieve.
	 * @return The value of the URI parameter if found, or `null` if the parameter is not present.
	 */
	@TestVisible
	protected String getUriParam(String paramName) {
		if (this.uriParamsMap == null) {
			this.parseUriParams();
		}
		return this.uriParamsMap.get(paramName);
	}

	/**
	 * Retrieves the value of a query parameter by its name from the current REST request.
	 * Query parameters are key-value pairs in the request's query string.
	 *
	 * @param paramName The name of the query parameter to retrieve.
	 * @return The value of the query parameter if found, or `null` if the parameter is not present.
	 */
	@TestVisible
	protected String getQueryParam(String paramName) {
		return this.request.params?.get(paramName);
	}

	/**
	 * Retrieves the value of an HTTP header by its name from the current REST request.
	 * HTTP headers are key-value pairs in the request's header section.
	 *
	 * @param headerName The name of the HTTP header to retrieve.
	 * @return The value of the HTTP header if found, or `null` if the header is not present.
	 */
	@TestVisible
	protected String getHeader(String headerName) {
		return this.request.headers?.get(headerName);
	}

	/**
	 * Parses the URI string based on the configured URI template and prepares a map of URI parameters.
	 * This method is automatically called when URI parameters need to be accessed.
	 *
	 * @throws RestFramework.InvalidUriException If the URI structure does not match the expected template.
	 */
	private void parseUriParams() {
		List<String> uriItems = this.request.requestURI.substringAfter('/').split('/');
		List<String> templateItems = this.uriTemplate.substringAfter('/').split('/');
		if (uriItems.size() != templateItems.size()) {
			throw new RestFramework.InvalidUriException(RestFramework.ERROR_MESSAGE_INVALID_URI + this.request.requestURI);
		}
		this.uriParamsMap = new Map<String, String>();
		while (!templateItems.isEmpty()) {
			String templateItem = templateItems.remove(0);
			String uriItem = uriItems.remove(0);
			if (templateItem.startsWith(':')) {
				this.uriParamsMap.put(templateItem.substringAfter(':'), uriItem);
			}
		}
	}

	/**
	 * Throws a RestFramework.MethodNotAllowedException with a message indicating that the current HTTP method is not allowed
	 * for the requested resource.
	 *
	 * @throws RestFramework.MethodNotAllowedException Thrown to indicate that the HTTP method is not allowed for the resource.
	 */
	private void throwMethodNotAllowedException() {
		throw new RestFramework.MethodNotAllowedException(
			String.format(
				RestFramework.ERROR_MESSAGE_METHOD_NOT_ALLOWED,
				new List<String>{this.request.httpMethod, this.request.requestURI}
			)
		);
	}
}