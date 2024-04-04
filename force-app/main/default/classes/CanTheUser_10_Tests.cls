
@isTest
private class CanTheUser_10_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    // Test to verify if the current user can edit an existing SObject
    @isTest
    static void testUserCanEditSObject() {
        // Retrieve the test account created in the test setup
        Account existingAccount = [SELECT Id, Name FROM Account LIMIT 1];
        
        // Bypass triggers before performing DML
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Call the method to test if the user can edit the account
        Boolean canEdit = CanTheUser.edit(existingAccount);
        
        // Assert that the user can edit the account
        System.assert(canEdit, 'The user should be able to edit the Account.');
        
        // Re-enable triggers after test
        TriggerHandler.clearBypass('AccountTriggerHandler');
        TriggerHandler.clearBypass('MDTAccountTriggerHandler');
    }
}
