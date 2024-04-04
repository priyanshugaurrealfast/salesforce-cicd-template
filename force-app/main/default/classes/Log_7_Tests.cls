
@isTest
private class Log_7_Tests {

    @testSetup
    static void setup() {
        // No specific setup is needed for these tests.
    }

    @isTest
    static void testPublishSingleException() {
        // Bypass triggers as per project specific details
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Use a dummy exception to avoid constructor issues
        Exception testException = new DmlException();

        // Get a reference to the Log singleton
        Log logger = Log.get();

        // Start the test context to monitor the DML operations
        Test.startTest();
        Integer dmlBefore = Limits.getDMLStatements();

        // Call the method that we want to test
        logger.publish(testException);

        Integer dmlAfter = Limits.getDMLStatements();
        // End the test context
        Test.stopTest();

        // Assert that a DML operation has occurred, indicating an event was published
        System.assertNotEquals(dmlBefore, dmlAfter, 'A DML operation should have taken place, which indicates that an event was published.');
    }
}
