
@isTest
private class CanTheUser_1_Tests {

    // Utility method to disable triggers
    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    // @testSetup to create necessary test data if needed
    @testSetup
    static void setup() {
        // Normally we would insert test data here, but for our testing purposes
        // we don't need actual data as we are testing schema level permissions
    }

    // Test method for valid object type using public API
    @isTest
    static void testFLSAccessibleForValidObjectType() {
        // Disable the triggers
        disableTriggers();
        // Use the public API to test the functionality of doLoad indirectly
        Test.startTest();
        Boolean isAccessible = CanTheUser.flsAccessible('Account', 'Name');
        Test.stopTest();

        // Assertions to ensure the FLS is being checked correctly
        System.assertNotEquals(null, isAccessible, 'The FLS should not be null for a valid object field');
        System.assert(isAccessible, 'The Name field on Account should be accessible');
    }

    // More test methods could be added here to indirectly test the doLoad functionality by using the public API
    // that utilizes the caching mechanism and the doLoad method internally.
}
