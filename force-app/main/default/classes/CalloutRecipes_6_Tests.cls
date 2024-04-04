
@isTest
private class CalloutRecipes_6_Tests {
    // Test setup to create test data
    @testSetup
    static void makeTestData() {
        // Prepare test data here
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert testAccounts;
    }
    
    // Mock class to simulate response
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

    // Happy path test
    @isTest
    static void testHttpPatchCalloutToSecondOrgSuccess() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'OK', '{}'));
        
        // Get test data
        List<Account> testAccounts = [SELECT Id, Name FROM Account];
        
        // Instantiate the class and call the target method
        CalloutRecipes recipes = new CalloutRecipes('NamedCredential');
        Test.startTest();
        Integer resultStatus = recipes.httpPatchCalloutToSecondOrg(testAccounts);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(200, resultStatus);
    }

    // Sad path test
    @isTest
    static void testHttpPatchCalloutToSecondOrgFailure() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(404, 'Not Found', '{}'));
        
        // Get test data
        List<Account> testAccounts = [SELECT Id, Name FROM Account];
        
        // Instantiate the class and call the target method
        CalloutRecipes recipes = new CalloutRecipes('NamedCredential');
        Test.startTest();
        Integer resultStatus = recipes.httpPatchCalloutToSecondOrg(testAccounts);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(200, resultStatus);
        System.assertEquals(404, resultStatus);
    }

    // Exceptional scenario test
    @isTest
    static void testHttpPatchCalloutToSecondOrgException() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Set up an account list with an invalid data that will cause serialization to fail
        Account badAccount = new Account(Name = null); // null name to force serialization error
        List<Account> testAccounts = new List<Account>{ badAccount };
        
        // Instantiate the class and call the target method
        CalloutRecipes recipes = new CalloutRecipes('NamedCredential');
        
        // Since we are testing for an exception scenario, we don't set up a mock response
        // Instead, we check if the method properly handles the exception and returns null
        Test.startTest();
        Integer resultStatus = recipes.httpPatchCalloutToSecondOrg(testAccounts);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(null, resultStatus);
    }
}
