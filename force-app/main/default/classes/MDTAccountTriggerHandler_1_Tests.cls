
@isTest
private class MDTAccountTriggerHandler_1_Tests {

    @testSetup
    static void setup() {
        // Create Account records for testing
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Test Account 1'));
        accounts.add(new Account(Name='Test Account 2'));
        insert accounts;
    }

    @isTest
    static void testBeforeUpdateHappyPath() {
        // Bypass other triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Retrieve an account to update
        Account testAccount = [SELECT Id, Name, BillingState FROM Account LIMIT 1];
        testAccount.Name = 'Updated Account Name';

        // Perform update operation
        Test.startTest();
        update testAccount;
        Test.stopTest();

        // Retrieve again and assert the BillingState has been set to 'IN'
        Account updatedAccount = [SELECT BillingState FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('IN', updatedAccount.BillingState, 'The BillingState should be set to IN');
    }

    // No sad path or exceptional scenario to test in this simple method as per the provided details.
}
