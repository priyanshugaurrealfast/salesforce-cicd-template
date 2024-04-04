
@isTest
private class CanTheUser_21_Tests {

    @testSetup
    static void setup() {
        // Prepare test data if necessary
        // As we're testing FLS permissions, creating test data is not required in this case
    }
    
    // Test method for when the user has update permission on the field
    @isTest
    static void testUserHasUpdatePermission() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Assuming Name is a field that user has update permission on Account object
        Boolean isUpdatable = CanTheUser.flsUpdatable('Account', 'Name');
        
        // Assert that the user has update permission on the field
        System.assertEquals(true, isUpdatable, 'User should have update permission on the Account Name field.');
    }
    
    // Test method for when the user does not have update permission on the field
    @isTest
    static void testUserLacksUpdatePermission() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Assuming Name is a field that user does not have update permission on Account object
        Boolean isUpdatable = CanTheUser.flsUpdatable('Account', 'BillingStreet');
        
        // Assert that the user does not have update permission on the field
        System.assertEquals(false, isUpdatable, 'User should not have update permission on the Account BillingStreet field.');
    }
    
    // Test method for when an invalid object name is provided
    @isTest
    static void testInvalidObjectName() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Use a non-existing object name
        Boolean isUpdatable = CanTheUser.flsUpdatable('InvalidObject', 'Name');
        
        // Assert should be false since the object is invalid
        System.assertEquals(false, isUpdatable, 'User should not have update permission on a field of a non-existing object.');
    }
    
    // Test method for when an invalid field name is provided
    @isTest
    static void testInvalidFieldName() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Use a non-existing field name on a valid object
        Boolean isUpdatable = CanTheUser.flsUpdatable('Account', 'NonExistingField');
        
        // Assert should be false since the field is invalid
        System.assertEquals(false, isUpdatable, 'User should not have update permission on a non-existing field of a valid object.');
    }
}
