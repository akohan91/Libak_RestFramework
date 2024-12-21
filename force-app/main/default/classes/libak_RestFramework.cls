/**
 * The `libak_RestFramework` class provides a structured framework for building RESTful web services in Salesforce Apex.
 * It includes interfaces for routing, response handling, error management, and logging, along with core components
 * for processing RESTful requests.
 */
public class libak_RestFramework {
	// Constants for HTTP status codes
	public static final Integer HTTP_CODE_OK = 200;
	public static final Integer HTTP_CODE_BAD_REQUEST = 400;
	public static final Integer HTTP_CODE_NOT_FOUND = 404;
	public static final Integer HTTP_CODE_METHOD_NOT_ALLOWED = 405;
	public static final Integer HTTP_CODE_INTERNAL_SERVER_ERROR = 500;

	// Constants for HTTP headers
	public static final String HEADER_NAME_CONTENT_TYPE = 'Content-Type';

	// Constants for content types
	public static final String CONTENT_TYPE_APPLICATION_JSON = 'application/json';
	public static final String CONTENT_TYPE_APPLICATION_PDF = 'application/pdf';

	// Constants for error messages
	public static final String ERROR_MESSAGE_INTERNAL_SERVER_ERROR = 'Internal Server Error';
	public static final String ERROR_MESSAGE_INVALID_URI = 'Invalid URI: ';
	public static final String ERROR_MESSAGE_METHOD_NOT_ALLOWED = 'The {0} http method is not available for this resource: {1}.';

	/**
	 * Handles an incoming REST request using the specified router.
	 *
	 * @param routerType The type of the router to use for routing the request.
	 */
	public static void handleRequest(Type routerType) {
		handleRequest(routerType, null);
	}

	/**
	 * Handles an incoming REST request using the specified router and error response factory.
	 *
	 * @param routerType            The type of the router to use for routing the request.
	 * @param loggerType The type of the logger to use for logging REST-related information (optional, can be null).
	 */
	public static void handleRequest(Type routerType, Type loggerType) {
		handleRequest(routerType, loggerType, libak_ErrorResponseFactory.class);
	}

	/**
	 * Handles an incoming REST request using the specified router, logger, and error response factory.
	 *
	 * @param routerType The type of the router to use for routing the request.
	 * @param loggerType The type of the logger to use for logging REST-related information (optional, can be null).
	 * @param errorResponseFactoryType The type of the error response factory to use for creating error responses (optional, can be null).
	 */
	public static void handleRequest(Type routerType, Type loggerType, Type errorResponseFactoryType) {
		IRestResponse response;
		IErrorResponseFactory errorResponseFactory;
		IRestLogger restLogger;
		try {
			errorResponseFactory = (IErrorResponseFactory)errorResponseFactoryType?.newInstance();
			restLogger = (IRestLogger)loggerType?.newInstance();
			restLogger?.initLog(RestContext.request);
			libak_RestRouter router = ((libak_RestRouter)routerType.newInstance()).setRoutes();
			libak_RestProcessor processor = router
			.newRestProcessor(RestContext.request, errorResponseFactory, restLogger);
			response = processor.process();
		} catch (Exception exc) {
			response = errorResponseFactory.newErrorRestResponse(exc);
			restLogger?.addErrorDetails(exc);
		} finally {
			response.sendResponse();
			restLogger?.createLog();
		}
	}

	/**
	 * The `IRestResponse` interface defines a method for sending REST responses.
	 */
	public interface IRestResponse {
		void sendResponse();
	}

	/**
	 * The `IErrorResponseFactory` interface defines a method for creating error responses.
	 */
	public interface IErrorResponseFactory {
		IRestResponse newErrorRestResponse(Exception exc);
	}

	/**
	 * The `IRestLogger` interface defines methods for logging REST-related information.
	 */
	public interface IRestLogger {
		void initLog(RestRequest request);
		void addErrorDetails(Exception exc);
		void createLog();
	}

	/**
	 * This exception is thrown when an invalid URI is encountered. It represents a client error (HTTP 400 Bad Request).
	 */
	public class InvalidUriException extends Exception {}

	/**
	 * This exception is thrown when an HTTP method is not allowed for a particular resource. It represents a client error (HTTP 405 Method Not Allowed).
	 */
	public class MethodNotAllowedException extends Exception {}
}