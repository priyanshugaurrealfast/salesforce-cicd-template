
@isTest
private class CanTheUser_20_Tests {

    @testSetup
    static void setup() {
        // Create test data for Account, since the original class checks fields on Account
        Account testAccount = new Account(Name = 'Test Account');
        // Populate other necessary fields as required
        insert testAccount;
    }
    
    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void test_UserHasAccessToAllFields() {
        disableTriggers();
        // Set up the fields we expect the user to have access to
        Set<String> fieldsToTest = new Set<String>{'Name', 'BillingStreet', 'BillingCity', 'BillingState'};

        // Call the target method
        Map<String, Boolean> fieldAccessMap = CanTheUser.bulkFLSAccessible('Account', fieldsToTest);

        // Assert that all fields have access
        for (String field : fieldsToTest) {
            System.assertEquals(true, fieldAccessMap.get(field), 'User should have access to ' + field);
        }
    }

    @isTest
    static void test_UserDoesNotHaveAccessToAnyField() {
        disableTriggers();
        // Set up the fields we expect the user not to have access to
        // These should be fields that are known to be restricted for the profile in use
        Set<String> fieldsToTest = new Set<String>{'CustomField__c'};

        // Call the target method
        Map<String, Boolean> fieldAccessMap = CanTheUser.bulkFLSAccessible('Account', fieldsToTest);

        // Assert that no fields have access
        for (String field : fieldsToTest) {
            System.assertEquals(false, fieldAccessMap.get(field), 'User should not have access to ' + field);
        }
    }

    @isTest
    static void test_UserHasAccessToSomeFields() {
        disableTriggers();
        // Assuming 'Name' is accessible and 'CustomField__c' is not
        Set<String> accessibleFields = new Set<String>{'Name'};
        Set<String> notAccessibleFields = new Set<String>{'CustomField__c'};
        Set<String> fieldsToTest = new Set<String>();
        fieldsToTest.addAll(accessibleFields);
        fieldsToTest.addAll(notAccessibleFields);

        // Call the target method
        Map<String, Boolean> fieldAccessMap = CanTheUser.bulkFLSAccessible('Account', fieldsToTest);

        // Assert that 'Name' is accessible and 'CustomField__c' is not
        for (String field : accessibleFields) {
            System.assertEquals(true, fieldAccessMap.get(field), 'User should have access to ' + field);
        }
        for (String field : notAccessibleFields) {
            System.assertEquals(false, fieldAccessMap.get(field), 'User should not have access to ' + field);
        }
    }

    @isTest
    static void test_ExceptionWithInvalidObject() {
        disableTriggers();
        // Set up an invalid object name
        String invalidObjectName = 'NonExistentObject';
        Set<String> fieldsToTest = new Set<String>{'SomeField'};

        Exception expectedException;
        try {
            // Call the target method, which should throw an exception due to invalid object name
            CanTheUser.bulkFLSAccessible(invalidObjectName, fieldsToTest);
        } catch (Exception e) {
            expectedException = e;
        }
        // Assert that an exception was thrown
        System.assertNotEquals(null, expectedException, 'An exception should have been thrown for invalid object name');
    }
}
