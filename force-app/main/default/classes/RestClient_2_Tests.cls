
@isTest
private class RestClient_2_Tests {
  
    // Use @testSetup to create reusable test data
    @testSetup
    static void setup() {
        // Test data setup if required
    }
  
    // A method to bypass triggers before each test method execution
    static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    // Mock class implementing HttpCalloutMock interface
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String contentType;
        private String responseBody;
        
        public MockHttpResponseGenerator(Integer statusCode, String contentType, String responseBody) {
            this.statusCode = statusCode;
            this.contentType = contentType;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(this.statusCode);
            response.setHeader('Content-Type', this.contentType);
            response.setBody(this.responseBody);
            return response;
        }
    }

    // Happy Path Test 1: Successful GET request
    @isTest
    static void testSuccessfulGetRequest() {
        bypassTriggers();
        // Setup mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'application/json', '{"success":true}'));
        // Make the call
        HttpResponse response = RestClient.makeApiCall('TestNamedCredential', RestClient.HttpVerb.GET, '/test/path', '');
        // Assertions
        System.assertEquals(200, response.getStatusCode(), 'The status code should be 200');
        System.assert(response.getBody().contains('success'), 'The response body should contain success message');
    }

    // More test methods would follow, where `Test.setMock` is used with appropriate instances of `MockHttpResponseGenerator`
    // ...

}
