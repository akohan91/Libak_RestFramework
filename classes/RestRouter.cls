/**
 * The `RestRouter` class is responsible for routing incoming REST requests to the appropriate `RestProcessor` based
 * on the requested URI. It maintains a mapping of routes to `RestProcessor` types and dynamically creates instances
 * of the appropriate processor.
 */
public virtual class RestRouter implements RestFramework.IRestRouter {
	protected Map<String, Type> routeToRestProcessorType;

	/**
	 * Constructs a new `RestRouter` instance with a mapping of routes to `RestProcessor` types.
	 *
	 * @param routeToRestProcessorType A map of routes to corresponding `RestProcessor` types.
	 */
	public RestRouter(Map<String, Type> routeToRestProcessorType) {
		this.routeToRestProcessorType = routeToRestProcessorType;
	}

	/**
	 * Creates a new `RestProcessor` instance for handling the incoming REST request without a custom error response factory
	 * and logger. This method provides a convenient way to create a `RestProcessor` with default error handling and logging.
	 *
	 * @param request The `RestRequest` object representing the incoming HTTP request.
	 * @return A new `RestProcessor` instance configured to handle the specified REST request.
	 * @throws RestFramework.InvalidUriException If the requested URI does not match any defined routes.
	 */
	public RestProcessor newRestProcessor(RestRequest request) {
		return this.newRestProcessor(request, new ErrorResponseFactory(), null);
	}

	/**
	 * Creates a new `RestProcessor` instance for handling the incoming REST request with a custom REST logger.
	 *
	 * @param request    The `RestRequest` object representing the incoming HTTP request.
	 * @param restLogger The custom REST logger to use for logging REST-related information.
	 * @return A new `RestProcessor` instance configured to handle the specified REST request with custom logging.
	 * @throws RestFramework.InvalidUriException If the requested URI does not match any defined routes.
	 */
	public RestProcessor newRestProcessor(RestRequest request, RestFramework.IRestLogger restLogger) {
		return this.newRestProcessor(request, new ErrorResponseFactory(), restLogger);
	}

	/**
	 * Creates a new `RestProcessor` instance for handling the incoming REST request with a custom error response factory
	 * and REST logger. This method dynamically selects the appropriate `RestProcessor` based on the requested URI.
	 *
	 * @param request              The `RestRequest` object representing the incoming HTTP request.
	 * @param errorResponseFactory The custom error response factory to use for generating error responses.
	 * @param restLogger           The custom REST logger to use for logging REST-related information.
	 * @return A new `RestProcessor` instance configured to handle the specified REST request with custom error handling and logging.
	 * @throws RestFramework.InvalidUriException If the requested URI does not match any defined routes.
	 */
	public RestProcessor newRestProcessor(RestRequest request, RestFramework.IErrorResponseFactory errorResponseFactory, RestFramework.IRestLogger restLogger) {
		List<String> sortedRoutes = new List<String>(this.routeToRestProcessorType.keySet());
		sortedRoutes.sort();
		while (sortedRoutes.size() > 0) {
			String route = sortedRoutes.remove(0);
			if (this.isRouteExists(route, request.requestURI)) {
				RestProcessor restProcessorItem = (RestProcessor)routeToRestProcessorType.get(route).newInstance();
				return restProcessorItem
					.useRestRequest(request)
					.useErrorResponseFactory(errorResponseFactory)
					.useRestLogger(restLogger)
					.useUriTemplate(route);
			}
		}
		throw new RestFramework.InvalidUriException(RestFramework.ERROR_MESSAGE_INVALID_URI + request.requestURI);
	}

	/**
	 * Checks if a route exists based on the requested URI.
	 *
	 * @param route      The route pattern to check.
	 * @param requestURI The requested URI.
	 * @return `true` if the route exists for the given URI, `false` otherwise.
	 */
	private Boolean isRouteExists(String route, String requestURI) {
		String routeTemplateRegEx = route
			.replaceAll('\\*', '\\.+')
			.replaceAll('\\:(.+?)/', '\\.+/')
			.replaceAll('\\:(.+?)$', '\\.+');
		return Pattern.matches('(?i)' + routeTemplateRegEx, requestURI);
	}
}