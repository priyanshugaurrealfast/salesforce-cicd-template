
@isTest
private class TriggerHandler_3_Tests {
    
    @isTest
    static void testClearMaxLoopCount() {
        // Arrange
        TriggerHandler testHandler = new TriggerHandler();
        testHandler.setMaxLoopCount(1);
        // Manually set the trigger context to simulate trigger execution
        testHandler.setTriggerContext('before insert', true);
        
        // Act
        testHandler.clearMaxLoopCount();
        
        // Assert
        // There is no direct way to check the private loopCountMap,
        // so we need to infer the clearing of max loop count by attempting
        // to run the handler more times than the original max loop count.
        // If the clearMaxLoopCount works, it would not throw any exception.
        
        try {
            // This would normally exceed the max loop count and throw an exception
            // but since we cleared it, it should not throw.
            for(Integer i = 0; i < 2; i++) {
                testHandler.run();
            }
            Boolean clearMaxLoopCountWorked = true;
            System.assertEquals(true, clearMaxLoopCountWorked, 'The max loop count should be cleared, allowing multiple runs without exception.');
        } catch(TriggerHandler.TriggerHandlerException e) {
            System.assert(false, 'clearMaxLoopCount did not work as expected.');
        }
    }
}
