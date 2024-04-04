
@isTest
private class Safely_8_Tests {

    @testSetup
    static void setup() {
        // Test data setup, assuming we are testing Account upserts
        Account testAccount = new Account(Name = 'Test Account');
        // Intentionally not inserting testAccount as the DML will be performed via the Safely class
    }
    
    // Test for successful upsert
    @isTest
    static void testSuccessfulUpsert() {
        Safely safely = new Safely();
        Account updatedAccount = new Account(Name = 'Updated Account');
        
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Test.startTest();
        List<Database.UpsertResult> results = safely.doUpsert(updatedAccount);
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'There should be one upsert result.');
        System.assert(results[0].isSuccess(), 'The upsert operation should be successful.');
    }
    
    // Test for failure to upsert due to lack of permissions
    @isTest
    static void testFailedUpsertDueToPermissions() {
        Safely safely = new Safely();
        Account accountWithoutPermission = new Account(Name = 'Account Without Permission');
        
        // Assume CanTheUser.edit or CanTheUser.create returns false for this record
        
        Test.startTest();
        List<Database.UpsertResult> results = safely.doUpsert(accountWithoutPermission);
        Test.stopTest();
        
        System.assertEquals(0, results.size(), 'No upsert result should be returned due to lack of permissions.');
    }
}
