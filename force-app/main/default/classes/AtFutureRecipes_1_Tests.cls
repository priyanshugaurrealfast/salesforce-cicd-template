
@isTest
private class AtFutureRecipes_1_Tests {

    @testSetup
    static void setup() {
        // If necessary, setup method would populate test data.
        // Currently not needed for testing the @future method without callout privileges.
    }
    
    @isTest
    static void ensureAtFutureMethodSetsCircuitBreaker() {
        // Bypass triggers as per project-specific details
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set test data for the future method
        String expectedData = 'Sample Future Method Test Data';

        // Start the test context
        Test.startTest();

        // Call the future method
        AtFutureRecipes.atFutureMethodWithoutCalloutPrivileges(expectedData);

        // Stop the test context to execute @future method
        Test.stopTest();

        // Assert that the circuit breaker has been tripped by the future method
        System.assertEquals(true, AtFutureRecipes.testCircuitBreaker, 'The testCircuitBreaker should be set to true.');
    }
}
