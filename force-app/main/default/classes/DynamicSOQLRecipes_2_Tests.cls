
@isTest
private class DynamicSOQLRecipes_2_Tests {

    // Test setup method to create test data
    @testSetup
    static void setup() {
        // Create a test account
        Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
    }
    
    // Helper method to disable triggers
    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testSimpleBindingSOQLQueryWithExistingAccount() {
        disableTriggers();
        // Query using the name of the account we set up in testSetup
        List<Account> accounts = DynamicSOQLRecipes.simpleBindingSOQLQuery('TestAccount');
        
        // Assert that we got exactly one account returned
        System.assertEquals(1, accounts.size(), 'One account should be returned');
        // Assert that the account name matches
        System.assertEquals('TestAccount', accounts[0].Name, 'Account name should match');
    }
    
    @isTest
    static void testSimpleBindingSOQLQueryWithNonExistingAccount() {
        disableTriggers();
        // Query using a non-existing account name
        List<Account> accounts = DynamicSOQLRecipes.simpleBindingSOQLQuery('NonExistingAccount');
        
        // Assert that no accounts are returned
        System.assertEquals(0, accounts.size(), 'No accounts should be returned');
    }
    
    @isTest
    static void testSimpleBindingSOQLQueryWithMaliciousInput() {
        disableTriggers();
        // Malicious input attempting SOQL injection
        String maliciousName = 'TestAccount\' OR \'1\'=\'1';
        
        // Perform the query with the malicious input
        List<Account> accounts = DynamicSOQLRecipes.simpleBindingSOQLQuery(maliciousName);
        
        // Assert that no accounts are returned, demonstrating our protection against SOQL injection
        System.assertEquals(0, accounts.size(), 'No accounts should be returned due to SOQL injection protection');
    }
}
