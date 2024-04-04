
@isTest
private class TriggerHandler_5_Tests {

    // This will bypass the required trigger handlers before running tests
    @testSetup
    static void makeTestData() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    // Happy Path: HandlerName is successfully cleared from the bypass set
    @isTest
    static void shouldSuccessfullyClearBypass() {
        // Preparing context for the test
        Test.startTest();

        // Act
        TriggerHandler.clearBypass('AccountTriggerHandler');

        // Assert
        Boolean isBypassed = TriggerHandler.isBypassed('AccountTriggerHandler');
        System.assertEquals(false, isBypassed, 'Handler should not be bypassed after being cleared.');

        Test.stopTest();
    }

    // Sad Path: HandlerName is not in the bypass set, so nothing happens
    @isTest
    static void shouldNotFailWhenClearingNonExistentBypass() {
        // Preparing context for the test
        Test.startTest();

        // Act
        TriggerHandler.clearBypass('NonExistentHandler'); // This handler was never added to bypassedHandlers

        // Assert
        Boolean isBypassed = TriggerHandler.isBypassed('NonExistentHandler');
        System.assertEquals(false, isBypassed, 'Handler should not be bypassed as it was never added.');

        Test.stopTest();
    }

    // Exceptional Scenario: HandlerName is null should not throw an exception and should not alter the bypass set
    @isTest
    static void shouldNotFailWhenClearingNullBypass() {
        // Prepare context for the test
        String nullHandlerName = null;
        Test.startTest();

        // Act: Attempt to clear a null bypass
        TriggerHandler.clearBypass(nullHandlerName);

        // Assert
        // Since a null handler name should not be in the bypass set, assert that the bypass for 'AccountTriggerHandler' is removed
        Boolean isBypassed = TriggerHandler.isBypassed('AccountTriggerHandler');
        System.assertEquals(false, isBypassed, 'AccountTriggerHandler should not be bypassed after clearing with null.');

        Test.stopTest();
    }
}
