
@isTest
public class TriggerHandler_7_Tests {

    // Test setup method to create necessary data
    @testSetup
    static void setup() {
        // For this particular method, we do not need to setup any test data.
    }
    
    // Test to ensure that bypassed handlers are no longer bypassed after clearAllBypasses is called
    @isTest
    static void testClearAllBypasses() {
        // Add handlers to the bypass list
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Pre-assertion to ensure that handlers are considered bypassed before clearing
        System.assertEquals(true, TriggerHandler.isBypassed('AccountTriggerHandler'), 'The AccountTriggerHandler should be bypassed before clearing.');
        System.assertEquals(true, TriggerHandler.isBypassed('MDTAccountTriggerHandler'), 'The MDTAccountTriggerHandler should be bypassed before clearing.');

        Test.startTest();
        TriggerHandler.clearAllBypasses();
        Test.stopTest();

        // Assert that handlers are no longer bypassed after clearing
        System.assertEquals(false, TriggerHandler.isBypassed('AccountTriggerHandler'), 'The AccountTriggerHandler should not be bypassed after clearing.');
        System.assertEquals(false, TriggerHandler.isBypassed('MDTAccountTriggerHandler'), 'The MDTAccountTriggerHandler should not be bypassed after clearing.');
    }
}
