@IsTest
public with sharing class libak_TestErrorResponse {

	@IsTest
	static void testErrorResponseInstance(){
		RestContext.response = new RestResponse();
		libak_RestFramework.IRestResponse response = new libak_ErrorResponse(
			libak_RestFramework.HTTP_CODE_NOT_FOUND,
			new libak_RestFramework.NotFoundException('Not found')
		);

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
			libak_RestFramework.HTTP_CODE_NOT_FOUND,
			RestContext.response.statusCode,
			'The status code of response should be 200'
		);
		System.assertEquals(
			Blob.valueOf(JSON.serialize(response)),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}

}