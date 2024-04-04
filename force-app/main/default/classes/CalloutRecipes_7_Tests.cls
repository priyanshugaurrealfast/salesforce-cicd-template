
@isTest
private class CalloutRecipes_7_Tests {
    
    @testSetup
    static void setup() {
        // Setup data if necessary
    }
    
    @isTest
    static void testHttpCalloutWithUntypedResponseSuccess() {
        // Given
        String jsonResponse = '{"key": "value"}';
        CalloutRecipes calloutRecipes = new CalloutRecipes('ExternalEndpoint');
        MockHttpResponseGenerator mockResponseGenerator = new MockHttpResponseGenerator(200, 'OK', jsonResponse, null);
        Test.setMock(HttpCalloutMock.class, mockResponseGenerator);
        
        // When
        Test.startTest();
        Map<String, Object> result = calloutRecipes.httpCalloutWithUntypedResponse();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals('value', result.get('key'), 'The value for "key" should be "value"');
    }
    
    @isTest
    static void testHttpCalloutWithUntypedResponseMalformedJson() {
        // Given
        String malformedJsonResponse = '{"key": "value"';
        CalloutRecipes calloutRecipes = new CalloutRecipes('ExternalEndpoint');
        MockHttpResponseGenerator mockResponseGenerator = new MockHttpResponseGenerator(200, 'OK', malformedJsonResponse, null);
        Test.setMock(HttpCalloutMock.class, mockResponseGenerator);
        
        // When
        Test.startTest();
        Map<String, Object> result = calloutRecipes.httpCalloutWithUntypedResponse();
        Test.stopTest();
        
        // Then
        System.assertEquals(null, result, 'The result should be null due to malformed JSON');
    }
    
    @isTest
    static void testHttpCalloutWithUntypedResponseCalloutFailure() {
        // Given
        String failureMessage = 'Internal Server Error';
        CalloutRecipes calloutRecipes = new CalloutRecipes('ExternalEndpoint');
        MockHttpResponseGenerator mockResponseGenerator = new MockHttpResponseGenerator(500, 'Internal Server Error', '', null);
        Test.setMock(HttpCalloutMock.class, mockResponseGenerator);
        
        // When
        Test.startTest();
        Map<String, Object> result = null;
        try {
            result = calloutRecipes.httpCalloutWithUntypedResponse();
        } catch (Exception e) {
            // Exception is expected
        }
        Test.stopTest();
        
        // Then
        System.assertEquals(null, result, 'The result should be null due to callout failure');
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String status;
        private String body;
        private Map<String, String> headers;
        
        public MockHttpResponseGenerator(Integer statusCode, String status, String body, Map<String, String> headers) {
            this.statusCode = statusCode;
            this.status = status;
            this.body = body;
            this.headers = headers;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(this.statusCode);
            response.setStatus(this.status);
            response.setBody(this.body);
            if (this.headers != null) {
                for (String key : this.headers.keySet()) {
                    response.setHeader(key, this.headers.get(key));
                }
            }
            return response;
        }
    }
}
