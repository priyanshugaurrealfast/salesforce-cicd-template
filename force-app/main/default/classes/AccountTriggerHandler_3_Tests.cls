
@isTest
private class AccountTriggerHandler_3_Tests {

    @testSetup
    static void makeData() {
        // Create test data for Account
        Account testAccount = new Account(
            Name = 'Test Account',
            ShippingState = 'CA',
            ShippingStreet = '123 Main St'
        );
        insert testAccount;
    }
    
    @isTest
    static void shouldPassWithValidShippingState() {
        // Given
        Account testAccount = [SELECT ShippingState, ShippingStreet FROM Account LIMIT 1];
        testAccount.ShippingState = 'NY'; // valid state length
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // When
        Test.startTest();
        update testAccount;
        Test.stopTest();
        
        // Then
        Account updatedAccount = [SELECT ShippingStreet FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('123 Main St before update trigger', updatedAccount.ShippingStreet, 'ShippingStreet should be appended with string');
    }
    
    @isTest
    static void shouldFailWithInvalidShippingState() {
        // Given
        Account testAccount = [SELECT ShippingState FROM Account LIMIT 1];
        testAccount.ShippingState = 'InvalidState'; // invalid state length
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // When
        Test.startTest();
        Database.SaveResult sr = Database.update(testAccount, false);
        Test.stopTest();
        
        // Then
        System.assert(!sr.isSuccess(), 'Update operation should not be successful');
        System.assert(sr.getErrors().size() > 0, 'There should be at least one error');
        System.assert(sr.getErrors()[0].getMessage().contains('Shipping State Length exceeds maximum allowed'), 'Error message should match expected validation error');
    }
    
    @isTest
    static void shouldPassWithNullShippingState() {
        // Given
        Account testAccount = [SELECT ShippingState, ShippingStreet FROM Account LIMIT 1];
        testAccount.ShippingState = null; // null state allowed
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // When
        Test.startTest();
        update testAccount;
        Test.stopTest();
        
        // Then
        Account updatedAccount = [SELECT ShippingStreet FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('123 Main St before update trigger', updatedAccount.ShippingStreet, 'ShippingStreet should be appended with string');
    }
}
