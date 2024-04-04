
@isTest
private class RestClient_1_Tests {

    @testSetup
    static void setup() {
        // Create test data if necessary
    }
    
    private static void setupTriggerBypass() {
        // Bypass the Account object triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String status;
        private String body;
        
        public MockHttpResponseGenerator(Integer statusCode, String status, String body) {
            this.statusCode = statusCode;
            this.status = status;
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(this.statusCode);
            res.setStatus(this.status);
            res.setBody(this.body);
            return res;
        }
    }

    @isTest
    static void testMakeApiCallGet() {
        setupTriggerBypass();
        
        // Set mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'OK', '{}'));
        
        // Perform a GET request using makeApiCall method
        RestClient.HttpVerb method = RestClient.HttpVerb.GET;
        String path = 'test/resource';
        
        Test.startTest();
        HttpResponse response = RestClient.makeApiCall('MockNamedCredential', method, path);
        Test.stopTest();
        
        // Assert the response is not null
        System.assertNotEquals(null, response, 'Response should not be null');
        // Assert the status code is OK (assuming MockNamedCredential is properly set up)
        System.assertEquals(200, response.getStatusCode(), 'Status code should be 200');
    }

    @isTest
    static void testMakeApiCallPost() {
        setupTriggerBypass();
        
        // Set mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'OK', '{}'));
        
        // Perform a POST request using makeApiCall method
        RestClient.HttpVerb method = RestClient.HttpVerb.POST;
        String path = 'test/resource';
        String body = '{"foo":"bar"}';
        
        Test.startTest();
        HttpResponse response = RestClient.makeApiCall('MockNamedCredential', method, path, '', body, null);
        Test.stopTest();
        
        // Assert the response is not null
        System.assertNotEquals(null, response, 'Response should not be null');
        // Assert the status code is OK (assuming MockNamedCredential is properly set up)
        System.assertEquals(200, response.getStatusCode(), 'Status code should be 200');
    }

    @isTest
    static void testMakeApiCallPatch() {
        setupTriggerBypass();
        
        // Set mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'OK', '{}'));
        
        // Perform a PATCH request using makeApiCall method
        RestClient.HttpVerb method = RestClient.HttpVerb.PATCH;
        String path = 'test/resource';
        String body = '{"foo":"updated"}';
        String query = 'id=1';
        
        Test.startTest();
        HttpResponse response = RestClient.makeApiCall('MockNamedCredential', method, path, query, body, null);
        Test.stopTest();
        
        // Assert the response is not null
        System.assertNotEquals(null, response, 'Response should not be null');
        // Assert the status code is OK (assuming MockNamedCredential is properly set up)
        System.assertEquals(200, response.getStatusCode(), 'Status code should be 200');
    }
    
    // Additional tests can be created to cover sad paths, and exceptional scenarios...
}
