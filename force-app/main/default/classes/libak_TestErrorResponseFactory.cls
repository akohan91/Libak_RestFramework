@IsTest
public with sharing class libak_TestErrorResponseFactory {
	@IsTest
	static void testCustomException(){
		RestContext.response = new RestResponse();
		libak_RestFramework.IErrorResponseFactory responseFactory = new libak_ErrorResponseFactory();
		Exception exc = new libak_RestFramework.MethodNotAllowedException('Error message');

		Test.startTest();

		libak_RestFramework.IRestResponse response = responseFactory.newErrorRestResponse(exc);
		response.sendResponse();

		Test.stopTest();

		System.assert(
			RestContext.response.headers.containsKey(libak_RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The response should have the "Content-Type" header.'
		);
		System.assertEquals(
			libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON,
			RestContext.response.headers.get(libak_RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The "Content-Type" header should be "application/json"'
		);
		System.assertEquals(
			libak_RestFramework.HTTP_CODE_METHOD_NOT_ALLOWED,
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
		libak_RestFramework.IErrorResponseFactory responseFactory = new libak_ErrorResponseFactory();
		Exception exc = new TestUnexpectedException('Error message');

		Test.startTest();

		libak_RestFramework.IRestResponse response = responseFactory.newErrorRestResponse(exc);
		response.sendResponse();

		Test.stopTest();

		System.assert(
			RestContext.response.headers.containsKey(libak_RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The response should have the "Content-Type" header.'
		);
		System.assertEquals(
			libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON,
			RestContext.response.headers.get(libak_RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The "Content-Type" header should be "application/json"'
		);
		System.assertEquals(
			libak_RestFramework.HTTP_CODE_INTERNAL_SERVER_ERROR,
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