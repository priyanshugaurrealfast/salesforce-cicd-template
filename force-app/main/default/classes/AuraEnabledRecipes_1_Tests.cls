
@isTest
public class AuraEnabledRecipes_1_Tests {

    @testSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    private static Id fetchTestAccountId() {
        return [SELECT Id FROM Account LIMIT 1].Id;
    }

    @isTest
    static void testUpdateAccountNameSuccess() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Id accountId = fetchTestAccountId();
        Boolean result = AuraEnabledRecipes.updateAccountName(accountId, 'Updated Name');
        
        Account updatedAccount = [SELECT Name FROM Account WHERE Id = :accountId];
        
        System.assertEquals(true, result, 'The update should be successful.');
        System.assertEquals('Updated Name', updatedAccount.Name, 'The account name should be updated.');
    }

    @isTest
    static void testUpdateAccountNameNoAccess() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Id accountId = fetchTestAccountId();
        Test.startTest();
        Test.stopTest();
        
        try {
            AuraEnabledRecipes.updateAccountName(accountId, 'Updated Name');
            System.assert(false, 'An exception should have been thrown.');
        } catch (AuraHandledException e) {
            System.assertEquals('User does not have access to edit Accounts', e.getMessage(), 'The exception message should match.');
        }
    }

    @isTest
    static void testUpdateAccountNameAccountDoesNotExist() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Id fakeId = '001XXXXXXXXXXXXXXX';
        
        Test.startTest();
        Test.stopTest();
        
        try {
            AuraEnabledRecipes.updateAccountName(fakeId, 'Updated Name');
            System.assert(false, 'An exception should have been thrown.');
        } catch (AuraHandledException e) {
            System.assertNotEquals(null, e.getMessage(), 'An exception message should be present.');
        }
    }

    @isTest
    static void testUpdateAccountNameDmlException() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Id accountId = fetchTestAccountId();
        
        // Make the DML fail by updating with an invalid field value
        // Assuming there's a validation rule or trigger that prevents "INVALID" as an account name
        Test.startTest();
        Test.stopTest();
        
        try {
            AuraEnabledRecipes.updateAccountName(accountId, 'INVALID');
            System.assert(false, 'An exception should have been thrown due to DML failure.');
        } catch (AuraHandledException e) {
            System.assertNotEquals(null, e.getMessage(), 'An exception message should be present.');
        }
    }
}
