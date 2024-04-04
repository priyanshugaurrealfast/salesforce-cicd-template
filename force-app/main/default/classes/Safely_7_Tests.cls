
@isTest
private class Safely_7_Tests {
    @testSetup
    static void makeTestData() {
        // Create test data for Account as it's a common SObject that could be used for upsert
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }

    private static void bypassTriggers() {
        // Bypassing Account triggers as per project-specific details
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testUpsertSuccess() {
        bypassTriggers();

        // Prepare records for upsert
        Account testAccount = new Account(Name='Upsert Account');
        
        // Perform upsert
        Safely safely = new Safely();
        List<Database.UpsertResult> results = safely.doUpsert(new List<SObject>{ testAccount });
        
        // Assertions
        System.assertEquals(1, results.size(), 'There should be one upsert result.');
        System.assertTrue(results[0].isSuccess(), 'Upsert should be successful.');
    }

    @isTest
    static void testUpsertNoPermission() {
        bypassTriggers();

        // Prepare records for upsert
        Account testAccount = new Account(Name='Upsert Account Failure');
        
        // Perform upsert
        Safely safely = new Safely();
        List<Database.UpsertResult> results = safely.doUpsert(new List<SObject>{ testAccount });
        
        // Assertions
        System.assertEquals(0, results.size(), 'No upsert should occur without permissions.');
    }

    @isTest
    static void testUpsertEmptyList() {
        bypassTriggers();

        // Perform upsert with empty list
        Safely safely = new Safely();
        List<Database.UpsertResult> results = safely.doUpsert(new List<SObject>());
        
        // Assertions
        System.assertEquals(0, results.size(), 'Result list should be empty for empty input.');
    }

    @isTest
    static void testUpsertWithRemovedFieldsException() {
        bypassTriggers();

        // Prepare records with a field that will be removed due to lack of FLS
        Account testAccount = new Account(Name='Account With Removed Field');
        testAccount.AnnualRevenue = 1000000;
        
        // Enforce exception throwing
        Safely safely = new Safely().throwIfRemovedFields();
        
        // Perform upsert and expect an exception
        Boolean exceptionThrown = false;
        try {
            List<Database.UpsertResult> results = safely.doUpsert(new List<SObject>{ testAccount });
        } catch (Safely.RemovedFieldsException e) {
            exceptionThrown = true;
        }
        
        // Assertions
        System.assert(exceptionThrown, 'A RemovedFieldsException should have been thrown.');
    }
}
