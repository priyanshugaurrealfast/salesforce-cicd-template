
@isTest
private class TriggerHandler_9_Tests {

    // Method to setup test data
    @testSetup
    static void setup() {
        // Create test data if needed
    }

    // Helper method to initialize TriggerHandler and set max loop count
    private static TriggerHandler initializeTriggerHandlerWithMaxLoopCount(Integer max) {
        TriggerHandler th = new TriggerHandler();
        th.setMaxLoopCount(max);
        return th;
    }

    // Tests that the loop count is incremented without exceeding the max
    @isTest
    static void testIncrementLoopCountWithinMax() {
        TriggerHandler th = initializeTriggerHandlerWithMaxLoopCount(3);
        th.setTriggerContext('before insert', true); // Simulate trigger context

        Test.startTest();
        th.run(); // Simulate trigger execution which would call addToLoopCount internally
        th.run(); // Simulate trigger execution again
        Test.stopTest();

        // Since loopCountMap is private, assertions must be made based on the expected behavior of the public interface
        System.assertEquals(true, th.validateRun(), 'TriggerHandler should still valid for execution');
    }

    // Tests that exceeding the maximum loop count throws an exception
    @isTest
    static void testIncrementLoopCountExceedsMax() {
        TriggerHandler th = initializeTriggerHandlerWithMaxLoopCount(1);
        th.setTriggerContext('before insert', true); // Simulate trigger context

        Test.startTest();
        th.run(); // Simulate trigger execution which would call addToLoopCount internally
        Boolean exceptionThrown = false;
        try {
            th.run(); // Simulate trigger execution again, should throw exception now
        } catch (TriggerHandler.TriggerHandlerException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'Exception should be thrown when exceeding loop count');
    }

    // Tests incrementing the loop count for a non-existing handler
    @isTest
    static void testIncrementNonExistingHandlerLoopCount() {
        TriggerHandler th = new TriggerHandler();
        th.setTriggerContext('before insert', true); // Simulate trigger context
        
        Test.startTest();
        th.run(); // Simulate trigger execution which would call addToLoopCount internally
        Test.stopTest();
        
        // Since loopCountMap is private, assertions must be made based on the expected behavior of the public interface
        System.assertEquals(true, th.validateRun(), 'TriggerHandler should still valid for execution for a new handler');
    }
}
