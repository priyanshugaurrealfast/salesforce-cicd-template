
@isTest
private class DynamicSOQLRecipes_1_Tests {

    @testSetup
    static void setup() {
        // Prepare test data with one Account record
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }
    
    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testSimpleDynamicSOQLQuery_WithRecord() {
        bypassTriggers();
        Test.startTest();
        
        List<Account> accounts = DynamicSOQLRecipes.simpleDynamicSOQLQuery();
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, accounts.size(), 'Should return one account');
        System.assertNotEquals(null, accounts[0].Id, 'Account should have an Id');
    }

    @isTest
    static void testSimpleDynamicSOQLQuery_WithoutRecords() {
        // Clean up all Account records to simulate no records scenario
        bypassTriggers();
        delete [SELECT Id FROM Account];
        
        Test.startTest();
        
        List<Account> accounts = DynamicSOQLRecipes.simpleDynamicSOQLQuery();
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, accounts.size(), 'Should return an empty list');
    }
}
