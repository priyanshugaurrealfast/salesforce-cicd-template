
@isTest
private class TriggerHandler_10_Tests {

    // Helper method to bypass triggers
    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    // Test for incrementing the loop count without exceeding the maximum
    @isTest
    static void testIncrementLoopCountWithinLimit() {
        bypassTriggers();
        
        TriggerHandler th = new TriggerHandler();
        th.setMaxLoopCount(5); // Set the maximum loop count to 5
        
        Test.startTest();
        Boolean exceeded = false;
        
        // Call addToLoopCount() 5 times which should not exceed the limit
        for (Integer i = 0; i < 5; i++) {
            try {
                th.addToLoopCount();
            } catch (TriggerHandler.TriggerHandlerException e) {
                exceeded = true;
                break;
            }
        }
        Test.stopTest();
        
        // Assertions
        System.assertEquals(false, exceeded, 'The loop count should not exceed the limit.');
    }
    
    // Test for exceeding the loop count and catching the expected exception
    @isTest
    static void testIncrementLoopCountExceedLimit() {
        bypassTriggers();
        
        TriggerHandler th = new TriggerHandler();
        th.setMaxLoopCount(1); // Set the maximum loop count to 1
        
        Test.startTest();
        Boolean exceeded = false;
        
        // First call to addToLoopCount() should work
        th.addToLoopCount();
        
        // Second call should throw an exception
        try {
            th.addToLoopCount();
        } catch (TriggerHandler.TriggerHandlerException e) {
            exceeded = true;
        }
        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, exceeded, 'An exception should have been thrown as the loop count exceeds the maximum.');
    }
}
