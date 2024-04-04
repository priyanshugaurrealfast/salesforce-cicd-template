
@isTest
private class TriggerHandler_12_Tests {

    @testSetup
    static void setup() {
        // Setup test data if required
    }
    
    // Helper method to disable the related triggers
    static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testGetMaxWithSetLoopCount() {
        disableTriggers();
        TriggerHandler.LoopCount lc = new TriggerHandler.LoopCount(3);
        Integer expectedMax = 3;
        Integer actualMax = lc.getMax();
        
        System.assertEquals(expectedMax, actualMax, 'The max loop count should be the set value of 3.');
    }
    
    @isTest
    static void testGetMaxWithDefaultLoopCount() {
        disableTriggers();
        TriggerHandler.LoopCount lc = new TriggerHandler.LoopCount();
        Integer expectedMax = 5; // Default value as set in the LoopCount constructor
        Integer actualMax = lc.getMax();
        
        System.assertEquals(expectedMax, actualMax, 'The max loop count should be the default value of 5.');
    }
    
    @isTest
    static void testGetMaxWithNegativeLoopCount() {
        disableTriggers();
        TriggerHandler.LoopCount lc = new TriggerHandler.LoopCount(-1);
        Integer expectedMax = -1;
        Integer actualMax = lc.getMax();
        
        System.assertEquals(expectedMax, actualMax, 'The max loop count should be the negative set value of -1.');
    }
}
