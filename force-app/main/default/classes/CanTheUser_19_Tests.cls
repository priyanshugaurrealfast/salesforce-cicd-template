
@isTest
private class CanTheUser_19_Tests {

    @testSetup
    static void setup() {
        // Setup test data with necessary permissions
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    @isTest
    static void testFLSAccessibleForAccessibleField() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assert that the flsAccessible method returns true for an accessible field
        Boolean isAccessible = CanTheUser.flsAccessible('Account', 'Name');
        System.assertEquals(true, isAccessible, 'The Name field should be accessible.');
    }

    @isTest
    static void testFLSAccessibleForNonAccessibleField() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assuming 'NonAccessibleField__c' is a non-accessible field on the Account object.
        Boolean isAccessible = CanTheUser.flsAccessible('Account', 'NonAccessibleField__c');
        System.assertEquals(false, isAccessible, 'The NonAccessibleField__c field should not be accessible.');
    }

    @isTest
    static void testFLSAccessibleForInvalidInput() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assert that the flsAccessible method returns false for an invalid field
        // Since we cannot create an invalid object, we will only test with a valid object and an invalid field.
        Boolean isAccessibleInvalidField = CanTheUser.flsAccessible('Account', 'InvalidField__c');
        System.assertEquals(false, isAccessibleInvalidField, 'An invalid field should not be accessible.');
    }
}
