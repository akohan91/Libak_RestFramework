@IsTest
public with sharing class TestErrorResponseFactory {
	@IsTest
	static void testCustomException(){
		RestContext.response = new RestResponse();
		RestFramework.IErrorResponseFactory responseFactory = new ErrorResponseFactory();
		Exception exc = new RestFramework.MethodNotAllowedException('Error message');

		Test.startTest();

		RestFramework.IRestResponse response = responseFactory.newErrorRestResponse(exc);
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

	@IsTest
	static void testUnexpectedException(){
		RestContext.response = new RestResponse();
		RestFramework.IErrorResponseFactory responseFactory = new ErrorResponseFactory();
		Exception exc = new TestUnexpectedException('Error message');

		Test.startTest();

		RestFramework.IRestResponse response = responseFactory.newErrorRestResponse(exc);
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
			RestFramework.HTTP_CODE_INTERNAL_SERVER_ERROR,
			RestContext.response.statusCode,
			'The status code of response should be 500'
		);
		System.assertEquals(
			Blob.valueOf(JSON.serialize(response)),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}

	private class TestUnexpectedException extends Exception {}
}