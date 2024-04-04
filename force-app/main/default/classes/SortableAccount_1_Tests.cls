
@isTest
private class SortableAccount_1_Tests {
    
    // Setting up test data for the test class
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>{
            new Account(Name='Test Account 1', ShippingCountry='USA'),
            new Account(Name='Test Account 2', ShippingCountry='Canada')
        };
        insert accounts;
    }
    
    // Test comparing two SortableAccount instances with same ShippingCountry
    @isTest
    static void testCompareToWithSameShippingCountry() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        List<Account> accounts = [SELECT Id, Name, ShippingCountry FROM Account];
        SortableAccount account1 = new SortableAccount(accounts[0]);
        SortableAccount account2 = new SortableAccount(accounts[0]);
        
        Integer comparisonResult = account1.compareTo(account2);
        
        System.assertEquals(0, comparisonResult, 'The accounts should be considered equal.');
    }

    // Test comparing two SortableAccount instances where one is greater
    @isTest
    static void testCompareToWithGreaterShippingCountry() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        List<Account> accounts = [SELECT Id, Name, ShippingCountry FROM Account ORDER BY ShippingCountry];
        SortableAccount account1 = new SortableAccount(accounts[1]); // Assuming Canada > USA
        SortableAccount account2 = new SortableAccount(accounts[0]);
        
        Integer comparisonResult = account1.compareTo(account2);
        
        System.assertEquals(1, comparisonResult, 'Account 1 should be considered greater than Account 2.');
    }

    // Test comparing two SortableAccount instances where one is less
    @isTest
    static void testCompareToWithLessShippingCountry() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        List<Account> accounts = [SELECT Id, Name, ShippingCountry FROM Account ORDER BY ShippingCountry DESC];
        SortableAccount account1 = new SortableAccount(accounts[1]); // Assuming USA < Canada
        SortableAccount account2 = new SortableAccount(accounts[0]);
        
        Integer comparisonResult = account1.compareTo(account2);
        
        System.assertEquals(-1, comparisonResult, 'Account 1 should be considered less than Account 2.');
    }

    // Test comparing SortableAccount instance with an object of another type
    @isTest
    static void testCompareToWithIncompatibleType() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Account acc = [SELECT Id, Name, ShippingCountry FROM Account LIMIT 1];
        SortableAccount sortableAccount = new SortableAccount(acc);
        String otherObject = 'Incompatible Type';
        
        Boolean caughtException = false;
        try {
            sortableAccount.compareTo(otherObject);
        } catch (SortableAccount.SortException e) {
            caughtException = true;
            System.assertEquals('Can\'t sort with incompatible type', e.getMessage(), 'Exception message should match expected');
        }
        
        System.assert(caughtException, 'A SortException should have been thrown.');
    }
}
