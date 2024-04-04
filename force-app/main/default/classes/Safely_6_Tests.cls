
@isTest
private class Safely_6_Tests {

    // Setup test data for all test methods
    @testSetup
    static void setupTestData() {
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create an Account record for testing purposes
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    // Test method for the happy path scenario
    @isTest
    static void testSuccessfulUpdate() {
        // Query the test account to get its ID
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        testAccount.Name = 'Updated Account Name';

        // Instantiate the Safely class
        Safely safely = new Safely();

        // Perform the update using the doUpdate method
        List<Database.SaveResult> saveResults = safely.doUpdate(testAccount);

        // Assertions
        System.assertEquals(1, saveResults.size(), 'There should be one save result.');
        System.assert(saveResults[0].isSuccess(), 'The update should be successful.');
    }
}
