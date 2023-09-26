@IsTest
public with sharing class TestRestRouter {

	public static final String URI_TEMPLATE = '/testRestRouter/:uriParam';

	@IsTest
	static void testNewRestProcessorWithCustomLoggerAndErrorResponseFactory(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/param_1';
		RestContext.request = request;
		RestRouter router = new RestRouterInstance().setRoutes();

		Test.startTest();

		RestProcessor processor = router.newRestProcessor(
			request,
			new TestErrorResponseFactory(),
			new TestRestLogger()
		);

		Test.stopTest();

		System.assertEquals(
			request,
			processor.request,
			'Wrong "request" property of RestProcessor instance.'
		);
		System.assertEquals(
			URI_TEMPLATE,
			processor.uriTemplate,
			'Wrong "uriTemplate" property of RestProcessor instance.'
		);
		System.assert(
			processor.errorResponseFactory instanceOf TestErrorResponseFactory,
			'Wrong "errorResponseFactory" property of RestProcessor instance.'
		);
		System.assert(
			processor.restLogger instanceOf TestRestLogger,
			'Wrong "errorResponseFactory" property of RestProcessor instance.'
		);
	}

	@IsTest
	static void testNewRestProcessorInvalidUriException(){
		RestRequest request = new RestRequest();
		request.requestURI = '/invalidURI';
		RestContext.request = request;
		RestRouter router = new RestRouterInstance().setRoutes();

		Test.startTest();

		try {
			RestProcessor processor = router.newRestProcessor(
				request,
				new TestErrorResponseFactory(),
				new TestRestLogger()
			);
			throw new TestCustomException('Go in to catch block.');
		} catch (Exception exc) {
			System.assertEquals(
				RestFramework.ERROR_MESSAGE_INVALID_URI + request.requestURI,
				exc.getMessage(),
				'Wrong exception message'
			);
			System.assert(
				exc instanceOf RestFramework.InvalidUriException,
				'Wrong exception type'
			);
		}

		Test.stopTest();
	}

	private class RestRouterInstance extends RestRouter {
		override public RestRouter setRoutes() {
			this.routeToRestProcessorType = new Map<String, Type>{
				URI_TEMPLATE => RestProcessor.class
			};
			return this;
		}
	}

	private class TestRestLogger implements RestFramework.IRestLogger {
		public void initLog(RestRequest request) {}
		public void addErrorDetails(Exception exc) {}
		public void createLog() {}
	}

	private class TestErrorResponseFactory implements RestFramework.IErrorResponseFactory {
		public RestFramework.IRestResponse newErrorRestResponse(Exception exc) {
			return null;
		}
	}

	private class TestCustomException extends Exception {}
}