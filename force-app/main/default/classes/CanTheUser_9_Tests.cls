
@isTest
private class CanTheUser_9_Tests {
    
    // Test setup method to create test data
    @testSetup
    static void setup() {
        // Since we're testing access, no need to insert data
    }
    
    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    // Test for the happy path where the user has read access to the object
    @isTest
    static void testReadAccessGranted() {
        bypassTriggers();
        Test.startTest();
        Boolean hasAccess = CanTheUser.read('Account');
        Test.stopTest();
        
        System.assert(hasAccess, 'The user should have read access to the Account object.');
    }
    
    // Test for the exceptional scenario where an invalid SObject name is provided
    @isTest
    static void testInvalidObjectName() {
        bypassTriggers();
        Test.startTest();
        Boolean hasAccess = CanTheUser.read('InvalidObjectName');
        Test.stopTest();
        
        System.assert(!hasAccess, 'The user should not have read access to an invalid object name.');
    }
}
