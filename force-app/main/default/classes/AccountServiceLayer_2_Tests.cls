
@isTest
private class AccountServiceLayer_2_Tests {

    @testSetup
    static void setup() {
        // Create test data for accounts
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }

    private static void bypassTriggers() {
        // Bypassing Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testChangeShippingStreetWithPermissions() {
        bypassTriggers();

        // Prepare test data
        List<Account> accounts = [SELECT Id, ShippingStreet FROM Account];
        
        // Assuming permissions are properly set and the user has permission
        // Actual permission handling logic to be replaced with project-specific implementation

        Test.startTest();
        // Call method under test
        AccountServiceLayer.changeShippingStreet(accounts);
        Test.stopTest();
        
        // Assertions
        Account updatedAccount = [SELECT ShippingStreet FROM Account WHERE Id = :accounts[0].Id];
        System.assertEquals('229b Baker st.', updatedAccount.ShippingStreet, 'The ShippingStreet should be updated to the hardcoded value.');
    }

    @isTest
    static void testChangeShippingStreetWithoutPermissions() {
        bypassTriggers();

        // Assuming user does not have the permission
        // Actual permission handling logic to be replaced with project-specific implementation

        // Mock no permissions
        Test.startTest();
        try {
            AccountServiceLayer.changeShippingStreet(new List<Account>{ new Account(Id = accounts[0].Id) });
            System.assert(false, 'An exception should have been thrown due to lack of permissions.');
        } catch (AccountServiceLayer.ASLException e) {
            System.assert(true, 'Correctly caught lack of permissions.');
        }
        Test.stopTest();
    }

    @isTest
    static void testChangeShippingStreetWithEmptyList() {
        bypassTriggers();

        // Call method under test with an empty list, which should be gracefully handled
        List<Account> emptyAccounts = new List<Account>();
        
        Test.startTest();
        AccountServiceLayer.changeShippingStreet(emptyAccounts);
        Test.stopTest();

        // No exceptions should be thrown and hence no assertions are required
    }

    @isTest
    static void testChangeShippingStreetWithNullList() {
        bypassTriggers();

        // Call method under test with a null list, which should be gracefully handled
        List<Account> nullAccounts = null;
        
        Test.startTest();
        AccountServiceLayer.changeShippingStreet(nullAccounts);
        Test.stopTest();

        // No exceptions should be thrown and hence no assertions are required
    }
}
