
@isTest
private class Safely_11_Tests {
    // Use @testSetup to create test data
    @testSetup
    static void setup() {
        // Bypass triggers before creating test data
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create an Account for testing the query
        Account testAccount = new Account(Name='TestAccount');
        insert testAccount;
    }

    // Happy Path: Query returns records and no fields are removed due to security
    @isTest
    static void testDoQueryWithResultsAndNoRemovedFields() {
        Safely safely = new Safely();
        Test.startTest();
        List<SObject> results = safely.doQuery('SELECT Name FROM Account WHERE Name=\'TestAccount\'');
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return 1 record');
        System.assertEquals('TestAccount', ((Account)results[0]).Name, 'Account Name should match');
    }

    // Sad Path: Query returns no records
    @isTest
    static void testDoQueryWithNoResults() {
        Safely safely = new Safely();
        Test.startTest();
        List<SObject> results = safely.doQuery('SELECT Name FROM Account WHERE Name=\'NonExistent\'');
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Should return no records');
    }
}
