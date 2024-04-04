
@isTest
private class ListSortingRecipes_2_Tests {
    
    @testSetup
    static void setup() {
        // Trigger bypassing
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test data
        List<Account> accounts = new List<Account>{
            new Account(Name='Account A', ShippingCountry='USA'),
            new Account(Name='Account B', ShippingCountry='Canada'),
            new Account(Name='Account C', ShippingCountry='Australia')
        };
        
        insert accounts;
    }
    
    @isTest
    static void testSortAccountsWithComparator_HappyPath() {
        List<Account> accountsToSort = [SELECT Id, Name, ShippingCountry FROM Account ORDER BY Name ASC];
        
        // Perform test
        Test.startTest();
        ListSortingRecipes.sortAccountsWithComparator(accountsToSort);
        Test.stopTest();
        
        // Assertions
        System.assertEquals('Australia', accountsToSort[0].ShippingCountry, 'The first account should be from Australia');
        System.assertEquals('Canada', accountsToSort[1].ShippingCountry, 'The second account should be from Canada');
    }
    
    @isTest
    static void testSortAccountsWithComparator_SadPath_EmptyList() {
        List<Account> emptyAccountsList = new List<Account>();
        
        // Perform test
        Test.startTest();
        ListSortingRecipes.sortAccountsWithComparator(emptyAccountsList);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, emptyAccountsList.size(), 'The list should remain empty');
    }
    
    @isTest
    static void testSortAccountsWithComparator_Exception_NullList() {
        List<Account> nullAccountsList = null;

        // Perform test
        Test.startTest();
        try {
            ListSortingRecipes.sortAccountsWithComparator(nullAccountsList);
            System.assert(false, 'Exception should have been thrown for null list');
        } catch (NullPointerException e) {
            System.assert(true, 'NullPointerException was expected');
        }
        Test.stopTest();
    }
}
