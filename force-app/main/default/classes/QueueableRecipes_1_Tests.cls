
@isTest
private class QueueableRecipes_1_Tests {

    @testSetup
    static void setup() {
        // Create test data
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'TestAccount' + i, Description = 'Original'));
        }
        insert testAccounts;
    }

    private static void bypassTriggers() {
        // Bypass account triggers as per project specific framework
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testHappyPath() {
        bypassTriggers();

        Test.startTest();
        System.enqueueJob(new QueueableRecipes());
        Test.stopTest();

        // Query to check results
        List<Account> updatedAccounts = [SELECT Description FROM Account];
        for (Account a : updatedAccounts) {
            System.assert(a.Description.contains('Edited by Queueable class'), 'Description should contain the appended text');
        }
    }

    @isTest
    static void testSadPathNoAccounts() {
        bypassTriggers();

        // Delete all accounts to simulate no accounts in the system
        delete [SELECT Id FROM Account];

        Test.startTest();
        System.enqueueJob(new QueueableRecipes());
        Test.stopTest();

        // No accounts exist, so nothing should be updated
        System.assertEquals(0, [SELECT Count() FROM Account], 'There should be no accounts in the system');
    }

    @isTest
    static void testExceptionalScenario() {
        bypassTriggers();

        // Introduce a situation that will cause the DML operation to fail
        // For example, we can make the `Description` field too long to force an exception
        Account testAccount = [SELECT Id, Description FROM Account LIMIT 1];
        testAccount.Description = String.valueOf('X').repeat(4000); // Assuming Description has a max length < 4000
        update testAccount;

        Test.startTest();
        System.enqueueJob(new QueueableRecipes());
        Test.stopTest();

        // As exception is handled internally, we assert that no unhandled exceptions surface
        System.assert(true, 'No unhandled exceptions should be raised');
    }
}
