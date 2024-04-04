
@isTest
private class Log_8_Tests {
    @testSetup
    static void setup() {
        // Set up any required test data here
    }

    private static Integer getBufferSize(Log logInstance) {
        // Since the buffer property is private, we would need to use reflection to access it
        // In a real test, we might need an accessor on the Log class to get the size of the buffer
        // For illustration purposes, we're returning 0
        return 0;
    }

    @isTest
    static void testPublishingNonEmptyStringMessage() {
        // Given
        Log logInstance = Log.get();
        String testMessage = 'Test Message';
        Integer initialBufferSize = getBufferSize(logInstance);

        // When
        Test.startTest();
        logInstance.publish(testMessage);
        Test.stopTest();

        // Then
        Integer finalBufferSize = getBufferSize(logInstance);
        System.assertEquals(initialBufferSize + 1, finalBufferSize, 'Buffer should have one more message before publishing.');
        System.assertEquals(0, finalBufferSize, 'Buffer should be cleared after publishing.');
    }

    @isTest
    static void testPublishingStringMessageWithExistingBufferContent() {
        // Given
        Log logInstance = Log.get();
        String initialMessage = 'Initial Message';
        String testMessage = 'Test Message';
        logInstance.add(initialMessage);
        Integer initialBufferSize = getBufferSize(logInstance);

        // When
        Test.startTest();
        logInstance.publish(testMessage);
        Test.stopTest();

        // Then
        Integer finalBufferSize = getBufferSize(logInstance);
        System.assertEquals(initialBufferSize + 1, finalBufferSize, 'Buffer should have one more message before publishing.');
        System.assertEquals(0, finalBufferSize, 'Buffer should be cleared after publishing.');
    }

    @isTest
    static void testPublishingNullStringMessage() {
        // Given
        Log logInstance = Log.get();
        String testMessage = null;
        Integer initialBufferSize = getBufferSize(logInstance);

        // When
        Test.startTest();
        logInstance.publish(testMessage);
        Test.stopTest();

        // Then
        Integer finalBufferSize = getBufferSize(logInstance);
        System.assertEquals(initialBufferSize + 1, finalBufferSize, 'Buffer should have one more message before publishing.');
        System.assertEquals(0, finalBufferSize, 'Buffer should be cleared after publishing.');
    }
}
