@IsTest
public with sharing class libak_TestRestRouter {

	public static final String URI_TEMPLATE = '/testRestRouter/:uriParam';

	@IsTest
	static void testNewRestProcessorWithCustomLoggerAndErrorResponseFactory(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/param_1';
		RestContext.request = request;
		libak_RestRouter router = new RestRouterInstance().setRoutes();

		Test.startTest();

		libak_RestProcessor processor = router.newRestProcessor(
			request,
			new libak_TestErrorResponseFactory(),
			new TestRestLogger()
		);

		Test.stopTest();

		System.assertEquals(
			request,
			processor.request,
			'Wrong "request" property of libak_RestProcessor instance.'
		);
		System.assertEquals(
			URI_TEMPLATE,
			processor.uriTemplate,
			'Wrong "uriTemplate" property of libak_RestProcessor instance.'
		);
		System.assert(
			processor.errorResponseFactory instanceOf libak_TestErrorResponseFactory,
			'Wrong "errorResponseFactory" property of libak_RestProcessor instance.'
		);
		System.assert(
			processor.restLogger instanceOf TestRestLogger,
			'Wrong "errorResponseFactory" property of libak_RestProcessor instance.'
		);
	}

	@IsTest
	static void testNewRestProcessorInvalidUriException(){
		RestRequest request = new RestRequest();
		request.requestURI = '/invalidURI';
		RestContext.request = request;
		libak_RestRouter router = new RestRouterInstance().setRoutes();

		Test.startTest();

		try {
			libak_RestProcessor processor = router.newRestProcessor(
				request,
				new libak_TestErrorResponseFactory(),
				new TestRestLogger()
			);
			throw new TestCustomException('Go in to catch block.');
		} catch (Exception exc) {
			System.assertEquals(
				libak_RestFramework.ERROR_MESSAGE_INVALID_URI + request.requestURI,
				exc.getMessage(),
				'Wrong exception message'
			);
			System.assert(
				exc instanceOf libak_RestFramework.InvalidUriException,
				'Wrong exception type'
			);
		}

		Test.stopTest();
	}

	private class RestRouterInstance extends libak_RestRouter {
		override public libak_RestRouter setRoutes() {
			this.routeToRestProcessorType = new Map<String, Type>{
				URI_TEMPLATE => libak_RestProcessor.class
			};
			return this;
		}
	}

	private class TestRestLogger implements libak_RestFramework.IRestLogger {
		public void initLog(RestRequest request) {}
		public void addErrorDetails(Exception exc) {}
		public void createLog() {}
	}

	private class libak_TestErrorResponseFactory implements libak_RestFramework.IErrorResponseFactory {
		public libak_RestFramework.IRestResponse newErrorRestResponse(Exception exc) {
			return null;
		}
	}

	private class TestCustomException extends Exception {}
}