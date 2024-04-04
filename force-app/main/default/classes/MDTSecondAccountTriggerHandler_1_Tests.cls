
@isTest
private class MDTSecondAccountTriggerHandler_1_Tests {
    
    @testSetup
    static void makeTestData() {
        // Create an Account record for testing purposes
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }
    
    @isTest
    static void testBeforeUpdate() {
        // Bypass related triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Retrieve the test account
        Account testAccount = [SELECT ShippingState FROM Account LIMIT 1];
        
        // Perform the update operation which should trigger beforeUpdate
        testAccount.Name = 'Test Account Updated';
        Test.startTest();
        update testAccount;
        Test.stopTest();
        
        // Query the account again to verify the ShippingState is set to 'IN'
        Account updatedAccount = [SELECT ShippingState FROM Account WHERE Id = :testAccount.Id];
        
        // Assertions to ensure the ShippingState is correctly set
        System.assertEquals('IN', updatedAccount.ShippingState, 'The ShippingState should be set to IN after update.');
    }
}
