# RestFramework - Salesforce Apex REST Framework

# Table of Contents
- [RestFramework - Salesforce Apex REST Framework](#restframework---salesforce-apex-rest-framework)
- [Table of Contents](#table-of-contents)
  - [`Overview`](#overview)
  - [`Constants`](#constants)
    - [HTTP Status Codes](#http-status-codes)
    - [HTTP Headers](#http-headers)
    - [Content Types](#content-types)
    - [Error Messages](#error-messages)
  - [`Interfaces`](#interfaces)
    - [RestFramework.IRestRouter](#restframeworkirestrouter)
    - [RestFramework.IRestResponse](#restframeworkirestresponse)
    - [RestFramework.IErrorResponseFactory](#restframeworkierrorresponsefactory)
    - [RestFramework.IRestLogger](#restframeworkirestlogger)
  - [`RestProcessor class`](#restprocessor-class)
    - [Constructors](#constructors)
      - [`RestProcessor()`](#restprocessor)
    - [Public Methods](#public-methods)
      - [`process()`](#process)
      - [`useUriTemplate(String uriTemplate)`](#useuritemplatestring-uritemplate)
      - [`useRestRequest(RestRequest request)`](#userestrequestrestrequest-request)
      - [`useErrorResponseFactory(RestFramework.IErrorResponseFactory errorResponseFactory)`](#useerrorresponsefactoryrestframeworkierrorresponsefactory-errorresponsefactory)
      - [`useRestLogger(RestFramework.IRestLogger restLogger)`](#userestloggerrestframeworkirestlogger-restlogger)
    - [Virtual Methods](#virtual-methods)
      - [`handleGet()`](#handleget)
      - [`handlePost()`](#handlepost)
      - [`handlePut()`](#handleput)
      - [`handlePatch()`](#handlepatch)
      - [`handleDelete()`](#handledelete)
    - [Protected Methods](#protected-methods)
      - [`getUriParam(String paramName)`](#geturiparamstring-paramname)
      - [`getQueryParam(String paramName)`](#getqueryparamstring-paramname)
      - [`getHeader(String headerName)`](#getheaderstring-headername)
    - [Private Methods](#private-methods)
      - [`parseUriParams()`](#parseuriparams)
      - [`throwMethodNotAllowedException()`](#throwmethodnotallowedexception)
  - [`RestRouter class`](#restrouter-class)
    - [Constructors](#constructors-1)
      - [`RestRouter(Map<String, Type> routeToRestProcessorType)`](#restroutermapstring-type-routetorestprocessortype)
    - [Public methods](#public-methods-1)
      - [`newRestProcessor(RestRequest request)`](#newrestprocessorrestrequest-request)
      - [`newRestProcessor(RestRequest request, RestFramework.IRestLogger restLogger)`](#newrestprocessorrestrequest-request-restframeworkirestlogger-restlogger)
      - [`newRestProcessor(RestRequest request, RestFramework.IErrorResponseFactory errorResponseFactory, RestFramework.IRestLogger restLogger)`](#newrestprocessorrestrequest-request-restframeworkierrorresponsefactory-errorresponsefactory-restframeworkirestlogger-restlogger)
    - [Private Methods](#private-methods-1)
      - [`isRouteExists(String route, String requestURI)`](#isrouteexistsstring-route-string-requesturi)
  - [`ErrorResponseFactory class`](#errorresponsefactory-class)
    - [Public Methods](#public-methods-2)
      - [`newErrorRestResponse(Exception exc)`](#newerrorrestresponseexception-exc)
  - [`SuccessResponse class`](#successresponse-class)
    - [Constructors](#constructors-2)
      - [`SuccessResponse(String data)`](#successresponsestring-data)
      - [`SuccessResponse(Blob data)`](#successresponseblob-data)
      - [`SuccessResponse(Integer statusCode, String data)`](#successresponseinteger-statuscode-string-data)
      - [`SuccessResponse(Integer statusCode, Blob data)`](#successresponseinteger-statuscode-blob-data)
    - [Public methods](#public-methods-3)
      - [`setHttpStatusCode(Integer statusCode)`](#sethttpstatuscodeinteger-statuscode)
      - [`addHeader(String key, String value)`](#addheaderstring-key-string-value)
      - [`sendResponse()`](#sendresponse)
  - [`JsonResponse class`](#jsonresponse-class)
    - [Constructors](#constructors-3)
      - [`JsonResponse(String data)`](#jsonresponsestring-data)
      - [`JsonResponse(Object data)`](#jsonresponseobject-data)
      - [`JsonResponse(Integer statusCode, String data)`](#jsonresponseinteger-statuscode-string-data)
      - [`JsonResponse(Integer statusCode, Object data)`](#jsonresponseinteger-statuscode-object-data)
    - [Public Methods](#public-methods-4)
      - [`addHeader(String key, String value)`](#addheaderstring-key-string-value-1)
      - [`sendResponse()`](#sendresponse-1)
  - [`ErrorResponse class`](#errorresponse-class)
    - [Constructors](#constructors-4)
      - [`ErrorResponse(Integer statusCode, String summary, String details)`](#errorresponseinteger-statuscode-string-summary-string-details)
      - [`ErrorResponse(Integer status, String summary, Exception exc)`](#errorresponseinteger-status-string-summary-exception-exc)
      - [`ErrorResponse(Integer status, Exception exc)`](#errorresponseinteger-status-exception-exc)
    - [Public Methods](#public-methods-5)
      - [`sendResponse()`](#sendresponse-2)
  - [`Custom Exceptions`](#custom-exceptions)

## `Overview`

The `RestFramework` class provides a structured framework for building RESTful web services in Salesforce Apex. It includes interfaces for routing, response handling, error management, and logging, along with core components for processing RESTful requests.

![RestFramework UML diagram](../assets/RestFrameworkUML.png)

## `Constants`

### HTTP Status Codes

- `RestFramework.HTTP_CODE_OK` (Integer): HTTP status code for a successful request (200).
- `RestFramework.HTTP_CODE_BAD_REQUEST` (Integer): HTTP status code for a bad request (400).
- `RestFramework.HTTP_CODE_NOT_FOUND` (Integer): HTTP status code for a not found resource (404).
- `RestFramework.HTTP_CODE_METHOD_NOT_ALLOWED` (Integer): HTTP status code for a method not allowed (405).
- `RestFramework.HTTP_CODE_INTERNAL_SERVER_ERROR` (Integer): HTTP status code for an internal server error (500).

### HTTP Headers

- `RestFramework.HEADER_NAME_CONTENT_TYPE` (String): The name of the HTTP header for specifying content type.

### Content Types

- `RestFramework.CONTENT_TYPE_APPLICATION_JSON` (String): Content type for JSON data.
- `RestFramework.CONTENT_TYPE_APPLICATION_PDF` (String): Content type for PDF data.

### Error Messages

- `RestFramework.ERROR_MESSAGE_INTERNAL_SERVER_ERROR` (String): Default error message for internal server errors.
- `RestFramework.ERROR_MESSAGE_INVALID_URI` (String): Error message for invalid URIs.
- `RestFramework.ERROR_MESSAGE_METHOD_NOT_ALLOWED` (String): Error message for unsupported HTTP methods.

## `Interfaces`

### RestFramework.IRestRouter

The `RestFramework.IRestRouter` interface defines methods for creating REST processors.

- `newRestProcessor(RestRequest request): RestProcessor`: Creates a new `RestProcessor` instance for handling the incoming REST request.
- `newRestProcessor(RestRequest request, RestFramework.IRestLogger restLogger): RestProcessor`: Creates a new `RestProcessor` instance with a custom REST logger.
- `newRestProcessor(RestRequest request, RestFramework.IErrorResponseFactory errorResponseFactory, RestFramework.IRestLogger restLogger): RestProcessor`: Creates a new `RestProcessor` instance with custom error response factory and REST logger.

### RestFramework.IRestResponse

The `RestFramework.IRestResponse` interface defines a method for sending REST responses.

- `sendResponse(): void`: Sends the REST response.

### RestFramework.IErrorResponseFactory

The `RestFramework.IErrorResponseFactory` interface defines a method for creating error responses.

- `newErrorRestResponse(Exception exc): RestFramework.IRestResponse`: Creates a new error response based on the given exception.

### RestFramework.IRestLogger

The `RestFramework.IRestLogger` interface defines methods for logging REST-related information.

- `addErrorDetails(Exception exc): void`: Adds error details to the logger.
- `createLog(): void`: Creates a log.

---

## `RestProcessor class`

The `RestProcessor` class serves as the base class for implementing specific REST processors. It includes methods for handling different HTTP methods, parsing URI parameters, and managing errors.

Certainly, here's the completion of the public methods section for the `RestProcessor` class:

### Constructors

#### `RestProcessor()`

Creates a new instance of the `RestProcessor` class.

### Public Methods

#### `process()`

Processes the incoming REST request by handling different HTTP methods and managing errors.

This method is the entry point for processing incoming REST requests. It dynamically dispatches the request to the appropriate handler based on the HTTP method (GET, POST, PUT, PATCH, DELETE). If an unsupported HTTP method is received, it throws a `RestFramework.MethodNotAllowedException`.

- Returns: An instance of `RestFramework.IRestResponse` representing the response to the REST request.
- Throws: `RestFramework.MethodNotAllowedException` - If the incoming HTTP method is not supported for this resource.

#### `useUriTemplate(String uriTemplate)`

Sets the URI template for this `RestProcessor`. The URI template defines the expected structure of the incoming URI, including any URI parameters.

- Parameters:
  - `uriTemplate` (String): The URI template to set, in the format "/service/resource/:paramName". The colon (:) is used to denote URI parameters, and the parameter name is used as the key for mapping URI values.
- Returns: The current `RestProcessor` instance with the URI template set.

#### `useRestRequest(RestRequest request)`

Sets the REST request for this `RestProcessor`. The REST request contains information about the incoming HTTP request, including the HTTP method, headers, and request parameters.

- Parameters:
  - `request` (RestRequest): The `RestRequest` object representing the incoming HTTP request.
- Returns: The current `RestProcessor` instance with the specified REST request set.

#### `useErrorResponseFactory(RestFramework.IErrorResponseFactory errorResponseFactory)`

Sets the error response factory for this `RestProcessor`.

- Parameters:
  - `errorResponseFactory` (RestFramework.IErrorResponseFactory): The error response factory to use.
- Returns: The current `RestProcessor` instance.

#### `useRestLogger(RestFramework.IRestLogger restLogger)`

Sets the REST logger for this `RestProcessor`.

- Parameters:
  - `restLogger` (RestFramework.IRestLogger): The REST logger to use.
- Returns: The current `RestProcessor` instance.

### Virtual Methods

The `RestProcessor` class includes a set of virtual methods for handling specific HTTP methods. These methods can be overridden in subclasses to implement custom request handling logic. If a virtual method is called without being overridden in a subclass, it will throw a `RestFramework.MethodNotAllowedException` indicating that the corresponding HTTP method is not supported for this resource.

#### `handleGet()`

Handles the HTTP GET method for processing REST requests.

- Returns: An instance of `RestFramework.IRestResponse` representing the response to the GET request.

#### `handlePost()`

Handles the HTTP POST method for processing REST requests.

- Returns: An instance of `RestFramework.IRestResponse` representing the response to the POST request.

#### `handlePut()`

Handles the HTTP PUT method for processing REST requests.

- Returns: An instance of `RestFramework.IRestResponse` representing the response to the PUT request.

#### `handlePatch()`

Handles the HTTP PATCH method for processing REST requests.

- Returns: An instance of `RestFramework.IRestResponse` representing the response to the PATCH request.

#### `handleDelete()`

Handles the HTTP DELETE method for processing REST requests.

- Returns: An instance of `RestFramework.IRestResponse` representing the response to the DELETE request.

### Protected Methods

The `RestProcessor` class includes a set of protected methods for internal use.

#### `getUriParam(String paramName)`

Retrieves the value of a URI parameter by its name. URI parameters are placeholders in the URI template specified when configuring the `RestProcessor`.

- Parameters:
  - `paramName` (String): The name of the URI parameter to retrieve.
- Returns: The value of the URI parameter if found, or `null` if the parameter is not present.

#### `getQueryParam(String paramName)`

Retrieves the value of a query parameter by its name from the current REST request. Query parameters are key-value pairs in the request's query string.

- Parameters:
  - `paramName` (String): The name of the query parameter to retrieve.
- Returns: The value of the query parameter if found, or `null` if the parameter is not present.

#### `getHeader(String headerName)`

Retrieves the value of an HTTP header by its name from the current REST request. HTTP headers are key-value pairs in the request's header section.

- Parameters:
  - `headerName` (String): The name of the HTTP header to retrieve.
- Returns: The value of the HTTP header if found, or `null` if the header is not present.

### Private Methods

#### `parseUriParams()`

Parses the URI string based on the configured URI template and prepares a map of URI parameters. This method is automatically called when URI parameters need to be accessed.

- Throws: `RestFramework.InvalidUriException` - If the URI structure does not match the expected template.

#### `throwMethodNotAllowedException()`

Throws a `RestFramework.MethodNotAllowedException` with a message indicating that the current HTTP method is not allowed for the requested resource.

- Throws: `RestFramework.MethodNotAllowedException` - Thrown to indicate that the HTTP method is not allowed for the resource.

---

## `RestRouter class`

The `RestRouter` class is responsible for routing incoming REST requests to the appropriate `RestProcessor` based on the requested URI. It maintains a mapping of routes to `RestProcessor` types and dynamically creates instances of the appropriate processor.
Certainly, here's the API reference documentation for the `RestRouter` class:

### Constructors

#### `RestRouter(Map<String, Type> routeToRestProcessorType)`

Constructs a new `RestRouter` instance with a mapping of routes to `RestProcessor` types.

- Parameters:
  - `routeToRestProcessorType` (Map<String, Type>): A map of routes to corresponding `RestProcessor` types.

### Public methods

#### `newRestProcessor(RestRequest request)`

Creates a new `RestProcessor` instance for handling the incoming REST request without a custom error response factory and logger. This method provides a convenient way to create a `RestProcessor` with default error handling and logging.

- Parameters:
  - `request` (RestRequest): The `RestRequest` object representing the incoming HTTP request.
- Returns: A new `RestProcessor` instance configured to handle the specified REST request.
- Throws: `RestFramework.InvalidUriException` - If the requested URI does not match any defined routes.

#### `newRestProcessor(RestRequest request, RestFramework.IRestLogger restLogger)`

Creates a new `RestProcessor` instance for handling the incoming REST request with a custom REST logger.

- Parameters:
  - `request` (RestRequest): The `RestRequest` object representing the incoming HTTP request.
  - `restLogger` (RestFramework.IRestLogger): The custom REST logger to use for logging REST-related information.
- Returns: A new `RestProcessor` instance configured to handle the specified REST request with custom logging.
- Throws: `RestFramework.InvalidUriException` - If the requested URI does not match any defined routes.

#### `newRestProcessor(RestRequest request, RestFramework.IErrorResponseFactory errorResponseFactory, RestFramework.IRestLogger restLogger)`

Creates a new `RestProcessor` instance for handling the incoming REST request with a custom error response factory and REST logger. This method dynamically selects the appropriate `RestProcessor` based on the requested URI.

- Parameters:
  - `request` (RestRequest): The `RestRequest` object representing the incoming HTTP request.
  - `errorResponseFactory` (RestFramework.IErrorResponseFactory): The custom error response factory to use for generating error responses.
  - `restLogger` (RestFramework.IRestLogger): The custom REST logger to use for logging REST-related information.
- Returns: A new `RestProcessor` instance configured to handle the specified REST request with custom error handling and logging.
- Throws: `RestFramework.InvalidUriException` - If the requested URI does not match any defined routes.

### Private Methods

#### `isRouteExists(String route, String requestURI)`

Checks if a route exists based on the requested URI.

- Parameters:
  - `route` (String): The route pattern to check.
  - `requestURI` (String): The requested URI.
- Returns: `true` if the route exists for the given URI, `false` otherwise.

---

## `ErrorResponseFactory class`

The `ErrorResponseFactory` class is responsible for creating error responses based on exceptions. It maps exception types to appropriate HTTP status codes and error messages.

### Public Methods

#### `newErrorRestResponse(Exception exc)`

Creates a new error response for the given exception.

- Parameters:
  - `exc` (Exception): The exception for which to create an error response.
- Returns: An error response based on the exception.

---

## `SuccessResponse class`

The `SuccessResponse` class represents a successful REST response. It allows developers to construct responses with custom data, status codes, and headers.

### Constructors

#### `SuccessResponse(String data)`

Constructs a new `SuccessResponse` with the provided data as a `String`.

- Parameters:
  - `data` (String): The data to include in the response.

#### `SuccessResponse(Blob data)`

Constructs a new `SuccessResponse` with the provided data as a `Blob`.

- Parameters:
  - `data` (Blob): The data to include in the response.

#### `SuccessResponse(Integer statusCode, String data)`

Constructs a new `SuccessResponse` with the specified status code and data as a `String`.

- Parameters:
  - `statusCode` (Integer): The HTTP status code for the response.
  - `data` (String): The data to include in the response.

#### `SuccessResponse(Integer statusCode, Blob data)`

Constructs a new `SuccessResponse` with the specified status code and data as a `Blob`.

- Parameters:
  - `statusCode` (Integer): The HTTP status code for the response.
  - `data` (Blob): The data to include in the response.

### Public methods

#### `setHttpStatusCode(Integer statusCode)`

Sets the HTTP status code for the response.

- Parameters:
  - `statusCode` (Integer): The HTTP status code to set.
- Returns: The current `SuccessResponse` instance.

#### `addHeader(String key, String value)`

Adds a header to the response.

- Parameters:
  - `key` (String): The header key.
  - `value` (String): The header value.
- Returns: The current `SuccessResponse` instance.

#### `sendResponse()`

Sends the success response with the configured status code, data, and headers. It sets the HTTP status code, response body, and headers in the RestContext's response object.

---

## `JsonResponse class`

The `JsonResponse` class represents a successful REST response with JSON data. It extends the `SuccessResponse` class and provides convenience methods for handling JSON data.

### Constructors

#### `JsonResponse(String data)`

Constructs a new `JsonResponse` with the provided JSON data as a string.

- Parameters:
  - `data` (String): The JSON data to include in the response.

#### `JsonResponse(Object data)`

Constructs a new `JsonResponse` with the provided JSON data as an object, serialized to a string.

- Parameters:
  - `data` (Object): The JSON data to include in the response.

#### `JsonResponse(Integer statusCode, String data)`

Constructs a new `JsonResponse` with the specified status code and JSON data as a string.

- Parameters:
  - `statusCode` (Integer): The HTTP status code for the response.
  - `data` (String): The JSON data to include in the response.

#### `JsonResponse(Integer statusCode, Object data)`

Constructs a new `JsonResponse` with the specified status code and JSON data as an object, serialized to a string.

- Parameters:
  - `statusCode` (Integer): The HTTP status code for the response.
  - `data` (Object): The JSON data to include in the response.

### Public Methods

#### `addHeader(String key, String value)`

Adds a header to the response.

- Parameters:
  - `key` (String): The header key.
  - `value` (String): The header value.
- Returns: The current `JsonResponse` instance.

#### `sendResponse()`

Sends the JSON response with the configured status code, data, and headers. It sets the HTTP status code, response body, and headers in the RestContext's response object.

---

## `ErrorResponse class`

The `ErrorResponse` class represents an error REST response. It allows developers to construct responses with custom error messages, status codes, and details.

### Constructors

#### `ErrorResponse(Integer statusCode, String summary, String details)`

Constructs a new `ErrorResponse` with the specified status code, summary, and details.

- Parameters:
  - `statusCode` (Integer): The HTTP status code for the error response.
  - `summary` (String): A summary message describing the error.
  - `details` (String): Additional details about the error.

#### `ErrorResponse(Integer status, String summary, Exception exc)`

Constructs a new `ErrorResponse` with the specified status code and summary, based on an exception.

- Parameters:
  - `status` (Integer): The HTTP status code for the error response.
  - `summary` (String): A summary message describing the error.
  - `exc` (Exception): The exception from which to derive error details.

#### `ErrorResponse(Integer status, Exception exc)`

Constructs a new `ErrorResponse` based on an exception. It sets the status code, summary, and details based on the exception's information.

- Parameters:
  - `status` (Integer): The HTTP status code for the error response.
  - `exc` (Exception): The exception from which to derive error details.

### Public Methods

#### `sendResponse()`

Sends the error response with the configured status code, summary, and details. It sets the HTTP status code, response body (serialized error information in JSON format), and content type header in the RestContext's response object.

---

## `Custom Exceptions`

- `RestFramework.InvalidUriException`: Exception class for invalid URIs.
- `RestFramework.NotFoundException`: Exception class for not found resources.
- `RestFramework.MethodNotAllowedException`: Exception class for unsupported HTTP methods.