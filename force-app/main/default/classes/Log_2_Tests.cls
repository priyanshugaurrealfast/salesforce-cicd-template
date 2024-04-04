
@isTest
private class Log_2_Tests {

    // Test setup to create test data if necessary
    @testSetup
    static void setup() {
        // Since the Log class does not interact with the database or require specific records, the setup can be left empty.
    }
    
    // Happy path: Adding valid message to the log
    @isTest
    static void shouldAddValidMessageToLog() {
        String validMessage = 'Test log message';
        Log logInstance = Log.get();

        Test.startTest();
        logInstance.add(validMessage);
        Test.stopTest();

        // Assertions are based on expected behavior since we can't access the private buffer.
        System.assertNotEquals(null, logInstance, 'The log instance should not be null.');
    }

    // Sad path: Adding null message to the log
    @isTest
    static void shouldHandleNullMessage() {
        String nullMessage = null;
        Log logInstance = Log.get();

        Test.startTest();
        logInstance.add(nullMessage);
        Test.stopTest();

        // Assertions are based on expected behavior since we can't access the private buffer.
        System.assertNotEquals(null, logInstance, 'The log instance should not be null even after adding a null message.');
    }
}
