
@isTest
private class DMLRecipes_3_Tests {

    // Create test data for all tests
    @testSetup
    static void makeTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    // Happy Path: User has permission and the account is successfully upserted
    @isTest
    static void testUpsertAccountWithPermissions() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Retrieve test data
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        testAccount.Name = 'Updated Account';
        
        // Perform the upsert operation
        Account upsertedAccount = DMLRecipes.upsertAccountViaUpsertKeyword(testAccount);
        
        // Assertions
        Test.startTest();
        System.assertNotEquals(null, upsertedAccount, 'Account should not be null');
        System.assertEquals('Updated Account', upsertedAccount.Name, 'Account name should be updated');
        Test.stopTest();
    }
}
