/**
 * The `RestRouter` class is responsible for routing incoming REST requests to the appropriate `RestProcessor` based
 * on the requested URI. It maintains a mapping of routes to `RestProcessor` types and dynamically creates instances
 * of the appropriate processor.
 */
public abstract class RestRouter {
	protected Map<String, Type> routeToRestProcessorType;

	/**
	 * Sets the routes for the `RestRouter`.
	 * Implement this method to define the routing logic.
	 * Implement to set the value for the `routeToRestProcessorType` property as <route>:<RestProcessor type>
	 *
	 * @return The current `RestRouter` instance.
	 */
	abstract public RestRouter setRoutes();

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