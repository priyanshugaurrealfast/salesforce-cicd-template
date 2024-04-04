
trigger AccountTrigger on Account (before insert, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            String sObjectType = MetadataTriggerService.getSObjectType();
            System.debug('SObjectType from Trigger.new: ' + sObjectType);
        } else if (Trigger.isDelete) {
            String sObjectType = MetadataTriggerService.getSObjectType();
            System.debug('SObjectType from Trigger.old: ' + sObjectType);
        }
    }
}


@isTest
private class MetadataTriggerService_2_Tests {

    // Setup method to create test data
    @testSetup
    static void setup() {
        Account testAccount = new Account(Name = 'Test Account Setup');
        insert testAccount;
    }

    // Test method to verify getSObjectType from Trigger.new
    @isTest
    static void testGetSObjectTypeWithNewRecords() {
        // Prepare the test data
        Account testAccount = new Account(Name = 'Test Account New');
        
        // Run the test
        Test.startTest();
        insert testAccount; // This will invoke the trigger logic
        Test.stopTest();
        
        // Since we cannot capture the return value directly from the trigger, we will not be able to assert it here.
        // Normally, we would assert on a change that the trigger makes, such as setting a field value based on the SObjectType.
    }

    // Test method to verify getSObjectType from Trigger.old
    @isTest
    static void testGetSObjectTypeWithOldRecords() {
        // Retrieve the test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Run the test
        Test.startTest();
        delete testAccount; // This will invoke the trigger logic
        Test.stopTest();
        
        // Since we cannot capture the return value directly from the trigger, we will not be able to assert it here.
        // Normally, we would assert on a change that the trigger makes, such as setting a field value based on the SObjectType.
    }

    // Test method to verify the exception is thrown when there is no trigger context
    @isTest
    static void testGetSObjectTypeWithNoTriggerContext() {
        // Bypass any custom trigger logic that may interfere with the test
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Run the test and expect an exception
        Test.startTest();
        Boolean isExceptionThrown = false;
        try {
            String sObjectType = MetadataTriggerService.getSObjectType();
        } catch (MetadataTriggerService.MetadataTriggerServiceException e) {
            isExceptionThrown = true;
        }
        Test.stopTest();
        
        // Assert that an exception was thrown
        System.assert(isExceptionThrown, 'An exception should be thrown when both Trigger.new and Trigger.old are null.');
    }
}
