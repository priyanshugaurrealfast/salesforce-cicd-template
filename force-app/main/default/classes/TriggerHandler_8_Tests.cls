
@isTest
public class TriggerHandler_8_Tests {
    
    private class TestTriggerHandler extends TriggerHandler {
        public Integer maxLoopCountReached = 0;
        
        protected override void beforeInsert() {
            try {
                this.addToLoopCount();
            } catch (TriggerHandlerException e) {
                maxLoopCountReached++;
            }
        }
    }

    @isTest
    static void testLoopCountWithinMaximum() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setMaxLoopCount(2);

        handler.setTriggerContext('before insert', true); // Simulate a 'before insert' context
        handler.run(); // This should invoke beforeInsert() and add to loop count
        
        handler.run(); // Try to add to loop count again without exceeding the maximum

        // Assert that no exception was thrown and loop count did not exceed the maximum
        System.assertEquals(0, handler.maxLoopCountReached, 'Loop count should not have reached the maximum');
    }

    @isTest
    static void testLoopCountExceedsMaximum() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setMaxLoopCount(1);

        handler.setTriggerContext('before insert', true); // Simulate a 'before insert' context
        handler.run(); // This should invoke beforeInsert() and add to loop count

        Boolean exceptionThrown = false;
        try {
            handler.run(); // Attempt to exceed the loop count
        } catch (TriggerHandler.TriggerHandlerException e) {
            exceptionThrown = true;
        }

        // Assert that the exception was thrown as expected
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when loop count exceeds maximum');
        System.assertEquals(1, handler.maxLoopCountReached, 'Loop count should have reached the maximum');
    }
    
    // Exceptional Scenario: Test that no maximum loop count is set (max < 0)
    @isTest
    static void testNoMaximumLoopCountSet() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.clearMaxLoopCount(); // This should set the max loop count to -1 which is unlimited

        handler.setTriggerContext('before insert', true); // Simulate a 'before insert' context
        
        for (Integer i = 0; i < 10; i++) {
            handler.run(); // Should be able to run multiple times without an exception
        }

        // Assert that no exception was thrown and loop count did not exceed
        System.assertEquals(0, handler.maxLoopCountReached, 'No maximum loop count should be set, and no exception thrown');
    }
}
