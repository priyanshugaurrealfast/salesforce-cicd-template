
@isTest
private class AccountServiceLayer_3_Tests {
    
    @testSetup
    static void makeTestData() {
        List<Account> accounts = new List<Account>{
            new Account(Name='Test Account 1', Description='5'),
            new Account(Name='Test Account 2', Description='non-integer'),
            new Account(Name='Test Account 3', Description=null)
        };
        insert accounts;
    }
    
    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testIncrementCounterValidDescription() {
        disableTriggers();
        List<Account> accounts = [SELECT Description FROM Account WHERE Name = 'Test Account 1'];
        List<Account> updatedAccounts = AccountServiceLayer.incrementCounterInDescription(accounts, false);
        
        System.assertEquals(1, updatedAccounts.size(), 'Should process one account');
        System.assertEquals('6', updatedAccounts[0].Description, 'Counter should increment by 1');
    }
    
    @isTest
    static void testIncrementCounterInvalidDescription() {
        disableTriggers();
        List<Account> accounts = [SELECT Description FROM Account WHERE Name = 'Test Account 2'];
        List<Account> updatedAccounts = AccountServiceLayer.incrementCounterInDescription(accounts, false);
        
        System.assertEquals(1, updatedAccounts.size(), 'Should process one account');
        System.assertEquals('2', updatedAccounts[0].Description, 'Counter should default to 0 then increment by 1');
    }
    
    @isTest
    static void testIncrementCounterNullDescription() {
        disableTriggers();
        List<Account> accounts = [SELECT Description FROM Account WHERE Name = 'Test Account 3'];
        List<Account> updatedAccounts = AccountServiceLayer.incrementCounterInDescription(accounts, false);
        
        System.assertEquals(1, updatedAccounts.size(), 'Should process one account');
        System.assertEquals('2', updatedAccounts[0].Description, 'Counter should default to 0 then increment by 1');
    }
    
    @isTest
    static void testIncrementCounterAndSave() {
        disableTriggers();
        List<Account> accounts = [SELECT Description FROM Account WHERE Name = 'Test Account 1'];
        List<Account> updatedAccounts = AccountServiceLayer.incrementCounterInDescription(accounts, true);
        
        System.assertNotEquals(null, updatedAccounts, 'Updated accounts should not be null');
        Account reloadedAccount = [SELECT Description FROM Account WHERE Id = :updatedAccounts[0].Id];
        System.assertEquals('7', reloadedAccount.Description, 'Counter should increment by 1 and account should be saved');
    }
}
