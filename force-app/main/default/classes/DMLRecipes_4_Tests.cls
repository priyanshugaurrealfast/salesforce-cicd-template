
@isTest
private class DMLRecipes_4_Tests {

    @testSetup
    static void setup() {
        // Create test data for Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testUpsertAccountViaDatabaseMethod_Success() {
        disableTriggers();

        Test.startTest();
        
        Account acctToUpdate = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        acctToUpdate.Name = 'Updated Account';
        Database.UpsertResult upsertResult = DMLRecipes.upsertAccountViaDatabaseMethod(acctToUpdate, false);
        
        Test.stopTest();
        
        // Assertions
        System.assert(upsertResult != null, 'UpsertResult should not be null.');
        System.assert(upsertResult.isSuccess(), 'Upsert should be successful.');
    }
}
