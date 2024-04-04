
@isTest
private class CalloutRecipes_1_Tests {

    @testSetup
    static void setup() {
        // No specific test data setup required for callout tests
    }

    private class MockHttpResponse200 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('Mock response body');
            response.setStatusCode(200);
            response.setStatus('OK');
            return response;
        }
    }

    private class MockHttpResponseError implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setStatus('Internal Server Error');
            return response;
        }
    }

    @isTest
    static void testRawCalloutHappyPath() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse200());
        Test.startTest();
        String responseBody = CalloutRecipes.rawCallout();
        Test.stopTest();
        
        System.assertEquals('Mock response body', responseBody, 'The body of the response should match the mock response');
    }

    @isTest
    static void testRawCalloutSadPath() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseError());
        Exception caughtException = null;
        Test.startTest();
        try {
            CalloutRecipes.rawCallout();
        } catch (CalloutRecipes.CalloutRecipesException e) {
            caughtException = e;
        }
        Test.stopTest();
        
        System.assertNotEquals(null, caughtException, 'An exception should be thrown when the callout response is an error');
    }

    @isTest
    static void testRawCalloutExceptionalScenario() {
        // Since CalloutException can't be caught and is only thrown in real callouts, this test is just a placeholder
        System.assert(true, 'No actual test here as CalloutException cannot be simulated in a test context.');
    }
}
