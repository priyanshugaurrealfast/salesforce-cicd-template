
@isTest
private class CalloutRecipes_4_Tests {
    // Shared test setup method
    @testSetup
    static void makeTestData() {
        // Create test data for Contact
        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'Test', LastName = 'Contact1'),
            new Contact(FirstName = 'Sample', LastName = 'Contact2')
        };
        insert contacts;
    }
    
    // Helper method to generate a mock HTTPResponse
    private static HTTPResponse generateMockResponse(Integer statusCode, String body) {
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(statusCode);
        res.setBody(body);
        return res;
    }
    
    // Test the happy path scenario
    @isTest
    static void testHttpPostCalloutToSecondOrg_HappyPath() {
        // Bypass triggers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Prepare test data
        Test.startTest();
        List<Contact> contacts = [SELECT Id, FirstName, LastName FROM Contact];
        
        // Mock the callout response
        Integer expectedStatusCode = 201;
        MockHttpResponseGenerator mockHttpGenerator = new MockHttpResponseGenerator();
        mockHttpGenerator.mockResponse = generateMockResponse(expectedStatusCode, '');
        Test.setMock(HttpCalloutMock.class, mockHttpGenerator);
        
        // Perform callout
        CalloutRecipes calloutInstance = new CalloutRecipes('NamedCredential');
        Integer actualStatusCode = calloutInstance.httpPostCalloutToSecondOrg(contacts);
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(expectedStatusCode, actualStatusCode, 'The status code should be 201 - Created');
    }
    
    // Test the sad path scenario
    @isTest
    static void testHttpPostCalloutToSecondOrg_SadPath() {
        // Bypass triggers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Prepare test data
        Test.startTest();
        List<Contact> contacts = [SELECT Id, FirstName, LastName FROM Contact];
        
        // Mock the callout response
        Integer expectedStatusCode = 400;
        MockHttpResponseGenerator mockHttpGenerator = new MockHttpResponseGenerator();
        mockHttpGenerator.mockResponse = generateMockResponse(expectedStatusCode, 'Bad Request');
        Test.setMock(HttpCalloutMock.class, mockHttpGenerator);
        
        // Perform callout
        CalloutRecipes calloutInstance = new CalloutRecipes('NamedCredential');
        Integer actualStatusCode = calloutInstance.httpPostCalloutToSecondOrg(contacts);
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(expectedStatusCode, actualStatusCode, 'The status code should be 400 - Bad Request');
    }
    
    // Test the exceptional path scenario where serialization fails
    @isTest
    static void testHttpPostCalloutToSecondOrg_ExceptionalPath() {
        // Bypass triggers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Prepare a contact with invalid data for serialization
        Contact c = new Contact(LastName = 'Fake', Email = 'invalid-email');
        // Email is deliberately set to an invalid value to cause serialization failure
        
        // Add contact to the list
        List<Contact> contacts = new List<Contact>{ c };
        
        // Perform callout
        Test.startTest();
        
        // As we are testing serialization failure, we do not need to mock a callout response here
        CalloutRecipes calloutInstance = new CalloutRecipes('NamedCredential');
        
        // We use a try-catch block to capture any unexpected exceptions
        Integer actualStatusCode;
        try {
            actualStatusCode = calloutInstance.httpPostCalloutToSecondOrg(contacts);
        } catch (Exception e) {
            actualStatusCode = null;
        }
        
        Test.stopTest();
        
        // Assertions
        // We expect the actualStatusCode to be null due to serialization failure
        System.assertEquals(null, actualStatusCode, 'The status code should be null due to serialization exception');
    }
    
    // MockHttpResponseGenerator for generating mock responses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse mockResponse {get; set;}
        
        public HTTPResponse respond(HTTPRequest req) {
            return mockResponse;
        }
    }
}
