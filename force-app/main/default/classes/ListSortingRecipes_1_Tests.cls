
@isTest
private class ListSortingRecipes_1_Tests {
    
    @testSetup
    static void createTestData() {
        // Create test accounts
        List<Account> accounts = new List<Account>{
            new Account(Name='Account A', ShippingCountry='USA'),
            new Account(Name='Account B', ShippingCountry='Canada'),
            new Account(Name='Account C', ShippingCountry='Mexico')
        };
        // Insert accounts
        insert accounts;
    }
    
    private static void bypassTriggers() {
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testSortingWithNonNullList() {
        bypassTriggers();
        // Retrieve test data
        List<Account> accounts = [SELECT Id, Name, ShippingCountry FROM Account ORDER BY CreatedDate ASC];
        // Perform the sort
        ListSortingRecipes.sortAccountsWithSortableWrapper(accounts);
        
        // Assertions
        System.assertEquals('Canada', accounts[0].ShippingCountry, 'The first account should be from Canada');
        System.assertEquals('Mexico', accounts[1].ShippingCountry, 'The second account should be from Mexico');
    }
    
    @isTest
    static void testSortingWithEmptyList() {
        bypassTriggers();
        // Create an empty list
        List<Account> accounts = new List<Account>();
        // Perform the sort
        ListSortingRecipes.sortAccountsWithSortableWrapper(accounts);
        
        // Assertions
        System.assertEquals(0, accounts.size(), 'The list should remain empty');
    }
    
    @isTest
    static void testSortingWithNullList() {
        bypassTriggers();
        // Perform the sort with a null list
        try {
            ListSortingRecipes.sortAccountsWithSortableWrapper(null);
            System.assert(false, 'Expected NullPointerException was not thrown');
        } catch (NullPointerException e) {
            System.assert(true, 'Expected NullPointerException was thrown');
        }
    }
}
