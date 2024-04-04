
@isTest
private class SOQLRecipes_8_Tests {
    
    @testSetup
    static void setup() {
        // Bypass triggers before setting up test data
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test data
        List<Account> accountsToInsert = new List<Account>{
            new Account(Name = 'Test Account 1', ShippingState = 'CA'),
            new Account(Name = 'Test Account 2', ShippingState = 'NY'),
            new Account(Name = 'Test Account 3', ShippingState = 'NY')
        };
        insert accountsToInsert;
    }
    
    @isTest
    static void testGetAccountRecordsInState_HappyPath() {
        List<Account> accountsInNY = SOQLRecipes.getAccountRecordsInState('NY');
        System.assertEquals(2, accountsInNY.size(), 'There should be 2 accounts with ShippingState NY');
        System.assertEquals('Test Account 2', accountsInNY[0].Name, 'The account name should be Test Account 2');
    }
    
    @isTest
    static void testGetAccountRecordsInState_SadPath() {
        List<Account> accountsInTX = SOQLRecipes.getAccountRecordsInState('TX');
        System.assertEquals(0, accountsInTX.size(), 'There should be no accounts with ShippingState TX');
    }
    
    @isTest
    static void testGetAccountRecordsInState_ExceptionalScenario() {
        Test.startTest();
        List<Account> accounts = SOQLRecipes.getAccountRecordsInState(null);
        Test.stopTest();
        System.assertEquals(0, accounts.size(), 'Query with null state should return no results');
    }
}
