/**
 * The `RestFramework` class provides a structured framework for building RESTful web services in Salesforce Apex.
 * It includes interfaces for routing, response handling, error management, and logging, along with core components
 * for processing RESTful requests.
 */
public class RestFramework {
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
	 * The `IRestRouter` interface defines methods for creating REST processors.
	 */
	public interface IRestRouter {
		RestProcessor newRestProcessor(RestRequest request);
		RestProcessor newRestProcessor(RestRequest request, IRestLogger restLogger);
		RestProcessor newRestProcessor(RestRequest request, IErrorResponseFactory errorResponseFactory, IRestLogger restLogger);
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
		void addErrorDetails(Exception exc);
		void createLog();
	}

	/**
	 * This exception is thrown when an invalid URI is encountered. It represents a client error (HTTP 400 Bad Request).
	 */
	public class InvalidUriException extends Exception {}

	/**
	 * This exception is thrown when a requested resource is not found. It represents a client error (HTTP 404 Not Found).
	 */
	public class NotFoundException extends Exception {}

	/**
	 * This exception is thrown when an HTTP method is not allowed for a particular resource. It represents a client error (HTTP 405 Method Not Allowed).
	 */
	public class MethodNotAllowedException extends Exception {}
}