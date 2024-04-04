
@isTest
private class Safely_3_Tests {

    @testSetup
    static void setup() {
        // Create test data if needed
        // Note: Setup data should be minimal as we need to test without actual DML
    }

    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testDoInsertWithPermissions() {
        bypassTriggers();
        Safely safely = new Safely();
        List<Account> accountsToInsert = new List<Account>{
            new Account(Name = 'Test Account 1')
        };

        // Mocking the CanTheUser class may be required to simulate permissions

        Test.startTest();
        List<Database.SaveResult> results = safely.doInsert(accountsToInsert);
        Test.stopTest();

        // Assertions
        System.assertEquals(1, results.size(), 'Should be exactly one result');
        System.assert(results[0].isSuccess(), 'Insert operation should succeed');
    }

    @isTest
    static void testDoInsertWithEmptyList() {
        bypassTriggers();
        Safely safely = new Safely();
        List<Account> accountsToInsert = new List<Account>(); // Empty list

        Test.startTest();
        List<Database.SaveResult> results = safely.doInsert(accountsToInsert);
        Test.stopTest();

        // Assertions
        System.assertEquals(0, results.size(), 'Should be no results due to empty list');
    }
}
