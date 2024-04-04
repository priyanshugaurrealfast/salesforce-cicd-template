
@isTest
private class SOQLRecipes_2_Tests {
    
    // Set up test data
    @testSetup
    static void makeTestData() {
        // Create a list of accounts
        List<Account> accountsToInsert = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            Account a = new Account(Name = 'Test Account ' + i);
            accountsToInsert.add(a);
        }
        insert accountsToInsert;
    }
    
    // Test method for the happy path
    @isTest
    static void testGetLargeNumberOfRecordsWithAccounts() {
        // Bypass triggers before DML
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Perform test
        Test.startTest();
        Integer count = SOQLRecipes.getLargeNumberOfRecords();
        Test.stopTest();
        
        // Assert that the number of accounts is as expected
        System.assertEquals(5, count, 'There should be exactly 5 accounts counted.');
    }
    
    // Test method for the sad path
    @isTest
    static void testGetLargeNumberOfRecordsWithoutAccounts() {
        // Bypass triggers before DML
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Delete accounts to simulate no accounts in org
        Test.startTest();
        delete [SELECT Id FROM Account];
        Integer count = SOQLRecipes.getLargeNumberOfRecords();
        Test.stopTest();
        
        // Assert that the count is zero when no accounts exist
        System.assertEquals(0, count, 'There should be no accounts counted.');
    }
}
