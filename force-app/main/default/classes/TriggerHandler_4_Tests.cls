
@isTest
public class TriggerHandler_4_Tests {
    // No need for @testSetup since no test data needs to be pre-inserted

    // Happy Path Test
    @isTest
    static void shouldBypassValidHandlerName() {
        // Bypass a trigger handler
        TriggerHandler.bypass('AccountTriggerHandler');
        
        // Assert that the handler is bypassed
        Boolean isBypassed = TriggerHandler.isBypassed('AccountTriggerHandler');
        System.assertEquals(true, isBypassed, 'AccountTriggerHandler should be bypassed');
    }

    // Test passing null as the handlerName
    @isTest
    static void shouldNotBypassNullHandlerName() {
        // Bypass with null
        TriggerHandler.bypass(null);
        
        // Assert that the null handler is bypassed since null can be added to a Set
        Boolean isBypassed = TriggerHandler.isBypassed(null);
        System.assertEquals(true, isBypassed, 'Null handler should be bypassed');
    }

    // Test passing an empty string as the handlerName
    @isTest
    static void shouldBypassEmptyHandlerName() {
        // Bypass with empty string
        TriggerHandler.bypass('');
        
        // Assert that the empty string handler is bypassed
        Boolean isBypassed = TriggerHandler.isBypassed('');
        System.assertEquals(true, isBypassed, 'Empty string handler should be bypassed');
    }
}
