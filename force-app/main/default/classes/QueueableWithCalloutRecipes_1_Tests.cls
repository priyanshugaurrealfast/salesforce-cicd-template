
@isTest
private class QueueableWithCalloutRecipes_1_Tests {

    // Mock class for HTTP callouts
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('Mock response');
            return res;
        }
    }
    
    @testSetup
    static void setup() {
        // Create test Accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
    }

    @isTest
    static void testExecuteHappyPath() {
        // Mock the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Enqueue the Queueable job
        Test.startTest();
        System.enqueueJob(new QueueableWithCalloutRecipes());
        Test.stopTest();
        
        // Assert Accounts were updated with the status code from the mock response
        List<Account> accounts = [SELECT Description FROM Account];
        for(Account acc : accounts) {
            System.assertEquals('200', acc.Description, 'The account description should be set to the status code of the mock callout response.');
        }
    }

    @isTest
    static void testExecuteDmlExceptionHandling() {
        // Mock the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Simulate an error condition
        QueueableWithCalloutRecipes.throwError = true;
        
        // Enqueue the Queueable job
        Test.startTest();
        System.enqueueJob(new QueueableWithCalloutRecipes());
        Test.stopTest();
        
        // Assert that the error handling logic was invoked
        System.assertEquals(true, QueueableWithCalloutRecipes.circuitBreakerThrown, 'The circuit breaker should be thrown when throwError is true.');
    }
}
