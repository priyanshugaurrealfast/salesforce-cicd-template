
@isTest
private class TriggerHandler_2_Tests {

    @testSetup
    static void setup() {
        // Common test data setup if needed
    }
    
    @isTest
    static void testSetMaxLoopCountDoesNotThrowException() {
        // Bypass triggers to avoid side effects
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        TestHandler handler = new TestHandler();
        handler.setMaxLoopCount(1);
        
        // Set the trigger context directly for test purposes
        handler.context = TriggerHandler.TriggerContext.AFTER_INSERT;
        handler.isTriggerExecuting = true;
        
        Test.startTest();
        // Call run method which should not throw an exception since we have mocked a trigger context
        try {
            handler.run();
            System.assert(true, 'Expected no exception when setMaxLoopCount is within allowed range.');
        } catch (TriggerHandler.TriggerHandlerException e) {
            System.assert(false, 'No exception should be thrown when setMaxLoopCount is within allowed range.');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateMaxLoopCountDoesNotThrowException() {
        // Bypass triggers to avoid side effects
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        TestHandler handler = new TestHandler();
        handler.setMaxLoopCount(1);
        handler.setMaxLoopCount(2);
        
        // Set the trigger context directly for test purposes
        handler.context = TriggerHandler.TriggerContext.AFTER_INSERT;
        handler.isTriggerExecuting = true;
        
        Test.startTest();
        // Call run method twice, which should not throw an exception since we have mocked a trigger context
        // And we expect the setMaxLoopCount to update the value correctly
        try {
            handler.run();
            handler.run();
            System.assert(true, 'Expected no exception when setMaxLoopCount is updated and within allowed range.');
        } catch (TriggerHandler.TriggerHandlerException e) {
            System.assert(false, 'No exception should be thrown when setMaxLoopCount is updated correctly.');
        }
        Test.stopTest();
    }
    
    // Helper class to expose the run method for testing since it's a protected method in TriggerHandler
    private class TestHandler extends TriggerHandler {
        public override void run() {
            super.run();
        }
    }
    
    // Additional tests would be written here as needed.
}
