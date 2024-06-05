@IsTest
public with sharing class TestRestProcessor {
	@IsTest
	static void testProcessGet(){
		checkMethodNotAllowedResponse('GET');
	}

	@IsTest
	static void testProcessPost(){
		checkMethodNotAllowedResponse('POST');
	}

	@IsTest
	static void testProcessPut(){
		checkMethodNotAllowedResponse('PUT');
	}

	@IsTest
	static void testProcessPatch(){
		checkMethodNotAllowedResponse('PATCH');
	}

	@IsTest
	static void testProcessDelete(){
		checkMethodNotAllowedResponse('DELETE');
	}

	@IsTest
	static void testProcessOther(){
		checkMethodNotAllowedResponse('OPTIONS');
	}

	@IsTest
	static void testGetUriParam(){
		String paramValue = 'param_1';
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/' + paramValue;
		RestProcessor processor = prepareDefaultRestProcessor(request);

		Test.startTest();

		String uriParam = processor.getUriParam('uriParam');

		Test.stopTest();

		System.assertEquals(1, processor.uriParamsMap.size(), 'The "uriParamsMap" property is wrong.');
		System.assertEquals(paramValue, uriParam, 'The uri param is wrong.');
	}

	@IsTest
	static void testGetQueryParam(){
		String paramName = 'query_param';
		String paramValue = 'param_1';
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/uri_param';
		request.addParameter(paramName, paramValue);
		RestProcessor processor = prepareDefaultRestProcessor(request);

		Test.startTest();

		String queryParam = processor.getQueryParam(paramName);

		Test.stopTest();

		System.assertEquals(paramValue, queryParam, 'The query param is wrong.');
	}

	@IsTest
	static void testGetHeader(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/uri_param';
		request.addHeader(RestFramework.HEADER_NAME_CONTENT_TYPE, RestFramework.CONTENT_TYPE_APPLICATION_JSON);
		RestProcessor processor = prepareDefaultRestProcessor(request);

		Test.startTest();

		String header = processor.getHeader(RestFramework.HEADER_NAME_CONTENT_TYPE);

		Test.stopTest();

		System.assertEquals(RestFramework.CONTENT_TYPE_APPLICATION_JSON, header, 'The header is wrong.');
	}

	private static RestProcessor prepareDefaultRestProcessor(RestRequest request) {
		return new RestProcessor()
			.useRestRequest(request)
			.useUriTemplate('/testRestRouter/:uriParam')
			.useRestLogger(null)
			.useErrorResponseFactory(new ErrorResponseFactory());
	}

	private static void checkMethodNotAllowedResponse(String httpMethod) {
		RestContext.request = new RestRequest();
		RestContext.request.httpMethod = httpMethod;
		RestContext.response = new RestResponse();

		RestProcessor processor = prepareDefaultRestProcessor(RestContext.request);

		Test.startTest();

		RestFramework.IRestResponse response = processor.process();
		response.sendResponse();

		Test.stopTest();

		System.assert(
			RestContext.response.headers.containsKey(RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The response should have the "Content-Type" header.'
		);
		System.assertEquals(
			RestFramework.CONTENT_TYPE_APPLICATION_JSON,
			RestContext.response.headers.get(RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The "Content-Type" header should be "application/json"'
		);
		System.assertEquals(
			RestFramework.HTTP_CODE_METHOD_NOT_ALLOWED,
			RestContext.response.statusCode,
			'The status code of response should be 405'
		);
		System.assertEquals(
			Blob.valueOf(JSON.serialize(response)),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}
}