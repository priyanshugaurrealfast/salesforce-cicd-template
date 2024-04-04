
@isTest
private class PlatformCacheBuilderRecipes_1_Tests {

    // Use testSetup to create test data
    @testSetup
    static void setup() {
        // Bypass the trigger handlers for Account to avoid side effects
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create a list of Accounts to be used in tests
        List<Account> accountList = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            accountList.add(new Account(Name = 'Test Account ' + i));
        }
        insert accountList;
    }

    // Test the happy path scenario
    @isTest
    static void testDoLoadWithAccounts() {
        PlatformCacheBuilderRecipes cacheBuilder = new PlatformCacheBuilderRecipes();
        Test.startTest();
        Object result = cacheBuilder.doLoad('anyKey');
        Test.stopTest();
        
        List<Account> accounts = (List<Account>)result;
        System.assertEquals(5, accounts.size(), 'There should be 5 accounts loaded from cache');
        System.assertEquals('Test Account 0', accounts[0].Name, 'First account name should match');
    }
}
