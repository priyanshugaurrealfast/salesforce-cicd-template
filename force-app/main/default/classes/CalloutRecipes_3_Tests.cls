
@isTest
private class CalloutRecipes_3_Tests {
    
    private class HttpCalloutMockImpl implements HttpCalloutMock {
        private Integer mockStatusCode;
        private String mockStatusBody;
        
        public HttpCalloutMockImpl(Integer statusCode, String statusBody) {
            this.mockStatusCode = statusCode;
            this.mockStatusBody = statusBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(this.mockStatusCode);
            res.setBody(this.mockStatusBody);
            return res;
        }
    }
    
    @testSetup
    static void setup() {
        // Create test data
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;
        
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    private static void prepareMock(Integer mockStatusCode, String mockStatusBody) {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl(mockStatusCode, mockStatusBody));
    }
    
    @isTest
    static void testHttpDeleteCalloutWithSuccessResponse() {
        // Arrange
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        // Set mock callout with success status code
        prepareMock(200, 'Success');
        
        // Act
        Test.startTest();
        CalloutRecipes calloutRecipes = new CalloutRecipes('NamedCredential');
        Integer statusCode = calloutRecipes.httpDeleteCalloutToSecondOrg(testContact.Id);
        Test.stopTest();
        
        // Assert
        System.assertEquals(200, statusCode, 'The status code should be 200 for a successful callout');
    }
    
    @isTest
    static void testHttpDeleteCalloutWithFailureResponse() {
        // Arrange
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        // Set mock callout with error status code
        prepareMock(404, 'Not Found');
        
        // Act
        Test.startTest();
        CalloutRecipes calloutRecipes = new CalloutRecipes('NamedCredential');
        Integer statusCode = calloutRecipes.httpDeleteCalloutToSecondOrg(testContact.Id);
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(200, statusCode, 'The status code should not be 200 for an unsuccessful callout');
    }
    
    // Additional test methods can be written for various other HTTP status codes, if necessary.
}
