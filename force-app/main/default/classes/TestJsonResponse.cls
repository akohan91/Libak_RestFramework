@IsTest
public with sharing class TestJsonResponse {

	private static final Map<String, String> TEST_RESPONSE_DATA = new Map<String, String>{
		'property_1' => 'value_1'
	};

	@IsTest
	static void testConstructorStringData(){
		RestContext.response = new RestResponse();
		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
		RestFramework.IRestResponse response = new JsonResponse(stringResponseData);

		Test.startTest();

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
			RestFramework.HTTP_CODE_OK,
			RestContext.response.statusCode,
			'The status code of response should be 200'
		);
		System.assertEquals(
			Blob.valueOf(stringResponseData),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}

	@IsTest
	static void testConstructorObjectData(){
		RestContext.response = new RestResponse();
		RestFramework.IRestResponse response = new JsonResponse(TEST_RESPONSE_DATA);

		Test.startTest();

		response.sendResponse();

		Test.stopTest();

		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
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
			RestFramework.HTTP_CODE_OK,
			RestContext.response.statusCode,
			'The status code of response should be 200'
		);
		System.assertEquals(
			Blob.valueOf(stringResponseData),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}

	@IsTest
	static void testConstructorStatusCodeAndStringData(){
		RestContext.response = new RestResponse();
		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
		RestFramework.IRestResponse response = new JsonResponse(RestFramework.HTTP_CODE_BAD_REQUEST, stringResponseData);

		Test.startTest();

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
			RestFramework.HTTP_CODE_BAD_REQUEST,
			RestContext.response.statusCode,
			'The status code of response should be 400'
		);
		System.assertEquals(
			Blob.valueOf(stringResponseData),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}

	@IsTest
	static void testConstructorStatusCodeAndObjectData(){
		RestContext.response = new RestResponse();
		RestFramework.IRestResponse response = new JsonResponse(RestFramework.HTTP_CODE_BAD_REQUEST, TEST_RESPONSE_DATA);

		Test.startTest();

		response.sendResponse();

		Test.stopTest();

		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
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
			RestFramework.HTTP_CODE_BAD_REQUEST,
			RestContext.response.statusCode,
			'The status code of response should be 400'
		);
		System.assertEquals(
			Blob.valueOf(stringResponseData),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}

	@IsTest
	static void testSendResponse(){
		RestContext.response = new RestResponse();
		RestFramework.IRestResponse response = new JsonResponse(TEST_RESPONSE_DATA);

		Test.startTest();

		response.sendResponse();

		Test.stopTest();

		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
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
			RestFramework.HTTP_CODE_OK,
			RestContext.response.statusCode,
			'The status code of response should be 200'
		);
		System.assertEquals(
			Blob.valueOf(stringResponseData),
			RestContext.response.responseBody,
			'The response responseBody is wrong'
		);
	}
}