
@isTest
private class CanTheUser_22_Tests {

    @testSetup
    static void setup() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
    }

    @isTest
    static void testUserHasUpdatePermissionOnAllFields() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Set<String> fields = new Set<String>{'Name', 'Phone', 'Website'};
        Map<String, Boolean> result = CanTheUser.bulkFLSUpdatable('Account', fields);

        System.assertEquals(true, result.get('Name'), 'User should be able to update Name field');
        System.assertEquals(true, result.get('Phone'), 'User should be able to update Phone field');
    }

    @isTest
    static void testUserHasUpdatePermissionOnSomeFields() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Set<String> fields = new Set<String>{'Name', 'Phone', 'NonUpdatableField'};
        Map<String, Boolean> result = CanTheUser.bulkFLSUpdatable('Account', fields);

        System.assertEquals(true, result.get('Name'), 'User should be able to update Name field');
        System.assertEquals(false, result.get('NonUpdatableField'), 'User should not be able to update NonUpdatableField');
    }

    @isTest
    static void testUserHasNoUpdatePermissionOnAnyField() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Set<String> fields = new Set<String>{'NonUpdatableField1', 'NonUpdatableField2'};
        Map<String, Boolean> result = CanTheUser.bulkFLSUpdatable('Account', fields);

        System.assertEquals(false, result.get('NonUpdatableField1'), 'User should not be able to update NonUpdatableField1');
        System.assertEquals(false, result.get('NonUpdatableField2'), 'User should not be able to update NonUpdatableField2');
    }

    @isTest
    static void testEmptyFieldsSet() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Set<String> fields = new Set<String>();
        Map<String, Boolean> result = CanTheUser.bulkFLSUpdatable('Account', fields);

        System.assertEquals(true, result.isEmpty(), 'Result should be empty when no fields are provided');
    }

    @isTest
    static void testInvalidObjectName() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Boolean isExceptionThrown = false;
        Set<String> fields = new Set<String>{'Name'};

        try {
            Map<String, Boolean> result = CanTheUser.bulkFLSUpdatable('InvalidObject', fields);
        } catch (Exception e) {
            isExceptionThrown = true;
        }

        System.assertEquals(true, isExceptionThrown, 'An exception should be thrown for an invalid object name');
    }

    @isTest
    static void testCaseSensitivityOfFieldNames() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Set<String> fields = new Set<String>{'name', 'NAME', 'NaMe'};
        Map<String, Boolean> result = CanTheUser.bulkFLSUpdatable('Account', fields);

        System.assertEquals(true, result.get('name'), 'User should be able to update Name field regardless of case');
        System.assertEquals(true, result.get('NaMe'), 'User should be able to update Name field regardless of case');
    }
}
