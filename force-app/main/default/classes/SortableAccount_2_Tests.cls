
@isTest
private class SortableAccount_2_Tests {

    @testSetup
    static void setup() {
        // Disabling triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Creating test data with ShippingCountry set
        List<Account> accounts = new List<Account>{
            new Account(Name='Test Account 1', ShippingCountry='USA'),
            new Account(Name='Test Account 2', ShippingCountry='Canada'),
            new Account(Name='Test Account 3', ShippingCountry='Mexico')
        };
        insert accounts;
    }
    
    @isTest
    static void testSortingWithMultipleCountries() {
        List<Account> accounts = [SELECT Id, Name, ShippingCountry FROM Account ORDER BY Name];
        Test.startTest();
        SortableAccount.sort(accounts);
        Test.stopTest();

        // Assuming that the sort is alphabetical based on ShippingCountry
        System.assertEquals('Canada', accounts[0].ShippingCountry);
        System.assertEquals('Mexico', accounts[1].ShippingCountry);
        System.assertEquals('USA', accounts[2].ShippingCountry);
    }
    
    @isTest
    static void testSortingEmptyList() {
        List<Account> emptyAccounts = new List<Account>();
        Test.startTest();
        SortableAccount.sort(emptyAccounts);
        Test.stopTest();

        // Assertions
        System.assertEquals(0, emptyAccounts.size(), 'Empty list should have size 0 after sorting');
    }
    
    @isTest
    static void testSortingWithNullCountries() {
        // Prepare accounts with null ShippingCountry values
        List<Account> accountsWithNulls = new List<Account>{
            new Account(Name='Test Account 4'),
            new Account(Name='Test Account 5', ShippingCountry='Australia')
        };
        insert accountsWithNulls;

        // Perform sorting
        List<Account> accounts = [SELECT Id, Name, ShippingCountry FROM Account WHERE ShippingCountry = null OR ShippingCountry = 'Australia'];
        Test.startTest();
        SortableAccount.sort(accounts);
        Test.stopTest();

        // Assertions - since the sorting criteria are not clear for nulls, we are just asserting that the sorting operation does not throw an error
        // and that it returns a list of the same size
        System.assertEquals(2, accounts.size(), 'Sorted list should remain the same size');
        System.assertEquals('Australia', accounts[1].ShippingCountry, 'The account with a defined ShippingCountry should be last');
    }
}
