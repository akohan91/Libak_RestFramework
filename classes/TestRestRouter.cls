@IsTest
public with sharing class TestRestRouter {
	@IsTest
	static void testNewRestProcessorWithRequestOnly(){
		RestRequest request = new RestRequest();
		String uriTemplate = '/testRestRouter/:uriParam';
		request.requestURI = '/testRestRouter/param_1';
		RestContext.request = request;
		RestFramework.IRestRouter router = new RestRouter(new Map<String, Type>{
			uriTemplate => RestProcessor.class
		});

		Test.startTest();

		RestProcessor processor = router.newRestProcessor(request);

		Test.stopTest();

		System.assertEquals(
			request,
			processor.request,
			'Wrong "request" property of RestProcessor instance.'
		);
		System.assertEquals(
			uriTemplate,
			processor.uriTemplate,
			'Wrong "uriTemplate" property of RestProcessor instance.'
		);
		System.assert(
			processor.errorResponseFactory instanceOf ErrorResponseFactory,
			'Wrong "errorResponseFactory" property of RestProcessor instance.'
		);
		System.assertEquals(
			null,
			processor.restLogger,
			'Wrong "restLogger" property of RestProcessor instance.'
		);
	}

	@IsTest
	static void testNewRestProcessorWithCustomLogger(){
		RestRequest request = new RestRequest();
		String uriTemplate = '/testRestRouter/:uriParam';
		request.requestURI = '/testRestRouter/param_1';
		RestContext.request = request;
		RestFramework.IRestRouter router = new RestRouter(new Map<String, Type>{
			uriTemplate => RestProcessor.class
		});

		Test.startTest();

		RestProcessor processor = router.newRestProcessor(request, new TestRestLogger());

		Test.stopTest();

		System.assertEquals(
			request,
			processor.request,
			'Wrong "request" property of RestProcessor instance.'
		);
		System.assertEquals(
			uriTemplate,
			processor.uriTemplate,
			'Wrong "uriTemplate" property of RestProcessor instance.'
		);
		System.assert(
			processor.errorResponseFactory instanceOf ErrorResponseFactory,
			'Wrong "errorResponseFactory" property of RestProcessor instance.'
		);
		System.assert(
			processor.restLogger instanceOf TestRestLogger,
			'Wrong "errorResponseFactory" property of RestProcessor instance.'
		);
	}

	@IsTest
	static void testNewRestProcessorWithCustomLoggerAndErrorResponseFactory(){
		RestRequest request = new RestRequest();
		String uriTemplate = '/testRestRouter/:uriParam';
		request.requestURI = '/testRestRouter/param_1';
		RestContext.request = request;
		RestFramework.IRestRouter router = new RestRouter(new Map<String, Type>{
			uriTemplate => RestProcessor.class
		});

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
			uriTemplate,
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
		String uriTemplate = '/testRestRouter/:uriParam';
		request.requestURI = '/invalidURI';
		RestContext.request = request;
		RestFramework.IRestRouter router = new RestRouter(new Map<String, Type>{
			uriTemplate => RestProcessor.class
		});

		Test.startTest();

		try {
			RestProcessor processor = router.newRestProcessor(request);
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

	private class TestRestLogger implements RestFramework.IRestLogger {
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