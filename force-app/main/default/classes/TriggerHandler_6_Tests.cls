
@isTest
private class TriggerHandler_6_Tests {

    // Test Setup to create data for test methods
    @testSetup
    static void setup() {
        // Normally, we'd create data here, but since isBypassed only checks a static variable, no data setup is required.
    }

    // Happy path: Handler is bypassed.
    @isTest
    static void testIsBypassedWhenHandlerIsBypassed() {
        // Given
        String handlerName = 'AccountTriggerHandler';
        TriggerHandler.bypass(handlerName);

        // When
        Boolean result = TriggerHandler.isBypassed(handlerName);

        // Then
        System.assertEquals(true, result, 'Handler should be bypassed');
    }

    // Sad path: Handler is not bypassed.
    @isTest
    static void testIsBypassedWhenHandlerIsNotBypassed() {
        // Given
        String handlerName = 'AccountTriggerHandler';
        // Don't call bypass method.

        // When
        Boolean result = TriggerHandler.isBypassed(handlerName);

        // Then
        System.assertEquals(false, result, 'Handler should not be bypassed');
    }

    // Testing clearBypass functionality alongside isBypassed.
    @isTest
    static void testIsBypassedAfterClearBypass() {
        // Given
        String handlerName = 'AccountTriggerHandler';
        TriggerHandler.bypass(handlerName);
        TriggerHandler.clearBypass(handlerName);

        // When
        Boolean result = TriggerHandler.isBypassed(handlerName);

        // Then
        System.assertEquals(false, result, 'Handler should not be bypassed after clearing bypass');
    }
}
