
@isTest
private class CalloutRecipes_5_Tests {
    
    @testSetup
    static void setup() {
        // Create test data for Contact
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            Contact newContact = new Contact(
                FirstName = 'TestFirstName' + i,
                LastName = 'TestLastName' + i,
                Email = 'test' + i + '@example.com'
            );
            contactList.add(newContact);
        }
        insert contactList;
    }

    // Mock class to simulate HTTP callouts
    private class MockHttpResponse implements HttpCalloutMock {
        protected Integer statusCode;
        protected String statusBody;
        public MockHttpResponse(Integer statusCode, String statusBody) {
            this.statusCode = statusCode;
            this.statusBody = statusBody;
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody(statusBody);
            return res;
        }
    }
    
    @isTest
    static void testHttpPutCalloutSuccess() {
        // Arrange
        List<Contact> contactList = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 5];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, 'Success'));
        
        // Act
        Test.startTest();
        CalloutRecipes calloutInstance = new CalloutRecipes('Second_Org');
        Integer result = calloutInstance.httpPutCalloutToSecondOrg(contactList);
        Test.stopTest();
        
        // Assert
        System.assertEquals(200, result, 'Status code should be 200 for successful callout');
    }
    
    @isTest
    static void testHttpPutCalloutWithEmptyList() {
        // Arrange
        List<Contact> emptyContactList = new List<Contact>();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(204, 'No Content'));
        
        // Act
        Test.startTest();
        CalloutRecipes calloutInstance = new CalloutRecipes('Second_Org');
        Integer result = calloutInstance.httpPutCalloutToSecondOrg(emptyContactList);
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, result, 'Status code should not be null even for empty list');
    }
    
    @isTest
    static void testHttpPutCalloutServerError() {
        // Arrange
        List<Contact> contactList = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 5];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(500, 'Internal Server Error'));
        
        // Act
        Test.startTest();
        CalloutRecipes calloutInstance = new CalloutRecipes('Second_Org');
        Integer result = calloutInstance.httpPutCalloutToSecondOrg(contactList);
        Test.stopTest();
        
        // Assert
        System.assertEquals(500, result, 'Status code should be 500 for server error');
    }
    
    @isTest
    static void testHttpPutCalloutSerializationError() {
        // Arrange
        // Intentionally not creating mock response as serialization will fail
        List<Contact> contactList = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 5];
        String invalidJsonString = '{"InvalidJson"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, invalidJsonString));
        
        // Act & Assert
        Test.startTest();
        CalloutRecipes calloutInstance = new CalloutRecipes('Second_Org');
        Integer result = calloutInstance.httpPutCalloutToSecondOrg(contactList);
        Test.stopTest();
        
        // Assert
        System.assertEquals(200, result, 'Status code should be 200 even if serialization logic is faulty');
    }
}
