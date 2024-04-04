
@isTest
private class CalloutRecipes_2_Tests {

    // MockHttpResponseGenerator is a separate class implementing the HttpCalloutMock interface
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String body;
        private Integer statusCode;
        
        public MockHttpResponseGenerator(String body, Integer statusCode) {
            this.body = body;
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(body);
            res.setStatusCode(statusCode);
            return res;
        }
    }
    
    @testSetup
    static void setup() {
        // Setup data for tests if necessary
    }
    
    // Test successful callout returning well-formed JSON
    @isTest
    static void testHttpGetCalloutToSecondOrg_Success() {
        // Prepare mock response
        String jsonResponse = '[{"Name":"Test Account 1"},{"Name":"Test Account 2"}]';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(jsonResponse, 200));
        
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        CalloutRecipes calloutRecipes = new CalloutRecipes('NamedCredential');

        Test.startTest();
        List<Account> accounts = calloutRecipes.httpGetCalloutToSecondOrg();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, accounts, 'The accounts should not be null');
        System.assertEquals(2, accounts.size(), 'There should be two accounts in the list');
    }

    // Test successful callout returning malformed JSON
    @isTest
    static void testHttpGetCalloutToSecondOrg_MalformedJson() {
        // Prepare mock response
        String malformedJsonResponse = '{"Name":"Test Account 1"},{"Name":"Test Account 2"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(malformedJsonResponse, 200));

        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        CalloutRecipes calloutRecipes = new CalloutRecipes('NamedCredential');

        Test.startTest();
        List<Account> accounts = calloutRecipes.httpGetCalloutToSecondOrg();
        Test.stopTest();

        // Assertions
        System.assertEquals(null, accounts, 'The accounts should be null due to malformed JSON');
    }

    // Test callout failure
    @isTest
    static void testHttpGetCalloutToSecondOrg_CalloutFailure() {
        // Prepare mock response
        String failedResponse = 'Callout failed';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(failedResponse, 500));

        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        CalloutRecipes calloutRecipes = new CalloutRecipes('NamedCredential');

        Test.startTest();
        List<Account> accounts = calloutRecipes.httpGetCalloutToSecondOrg();
        Test.stopTest();

        // Assertions
        System.assertEquals(null, accounts, 'The accounts should be null due to callout failure');
    }
}
