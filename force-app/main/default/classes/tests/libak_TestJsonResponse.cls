@IsTest
public with sharing class libak_TestJsonResponse {

	private static final Map<String, String> TEST_RESPONSE_DATA = new Map<String, String>{
		'property_1' => 'value_1'
	};

	@IsTest
	static void testConstructorStringData(){
		RestContext.response = new RestResponse();
		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
		libak_RestFramework.IRestResponse response = new libak_JsonResponse(stringResponseData);

		Test.startTest();

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
			libak_RestFramework.HTTP_CODE_OK,
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
		libak_RestFramework.IRestResponse response = new libak_JsonResponse(TEST_RESPONSE_DATA);

		Test.startTest();

		response.sendResponse();

		Test.stopTest();

		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
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
			libak_RestFramework.HTTP_CODE_OK,
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
		libak_RestFramework.IRestResponse response = new libak_JsonResponse(libak_RestFramework.HTTP_CODE_BAD_REQUEST, stringResponseData);

		Test.startTest();

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
			libak_RestFramework.HTTP_CODE_BAD_REQUEST,
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
		libak_RestFramework.IRestResponse response = new libak_JsonResponse(libak_RestFramework.HTTP_CODE_BAD_REQUEST, TEST_RESPONSE_DATA);

		Test.startTest();

		response.sendResponse();

		Test.stopTest();

		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
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
			libak_RestFramework.HTTP_CODE_BAD_REQUEST,
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
		libak_RestFramework.IRestResponse response = new libak_JsonResponse(TEST_RESPONSE_DATA);

		Test.startTest();

		response.sendResponse();

		Test.stopTest();

		String stringResponseData = JSON.serialize(TEST_RESPONSE_DATA);
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
			libak_RestFramework.HTTP_CODE_OK,
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