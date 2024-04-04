
@isTest
private class BatchApexRecipes_2_Tests {

    @testSetup
    static void makeTestData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    }

    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testHappyPath() {
        bypassTriggers();
        
        Test.startTest();
        Database.executeBatch(new BatchApexRecipes());
        Test.stopTest();

        List<Account> updatedAccounts = [SELECT Name FROM Account WHERE Name LIKE '%Edited by Batch class%'];
        
        System.assertEquals(5, updatedAccounts.size(), 'All accounts should be updated');
        for (Account acct : updatedAccounts) {
            System.assert(acct.Name.endsWith(' Edited by Batch class'), 'Account name should be appended with specific text');
        }
    }

    @isTest
    static void testSadPathWithDmlFailures() {
        bypassTriggers();

        BatchApexRecipes batch = new BatchApexRecipes();
        batch.throwError = true;
        
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        System.assertEquals('Successes: 0 Failures: 5', BatchApexRecipes.result, 'There should be 5 failures and no successes');
    }

    @isTest
    static void testEmptyScope() {
        bypassTriggers();

        BatchApexRecipes batch = new BatchApexRecipes();

        List<Account> accountsToDelete = [SELECT Id FROM Account];
        delete accountsToDelete;

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        // After deleting the accounts, there should be no accounts to process
        System.assertEquals('Successes: 0 Failures: 0', BatchApexRecipes.result, 'No accounts should be processed');
    }
}
