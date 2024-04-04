
@isTest
private class Log_3_Tests {

    // Placeholder enum for LogSeverity
    // Please replace with actual LogSeverity enum from your org if different
    private enum LogSeverity { DEBUG, INFO, WARN, ERROR, FATAL }
    
    // Placeholder class for LogMessage
    // Assuming LogMessage is a Platform Event or an sObject that we can mock
    private class MockLogMessage {
        public String message;
        public LogSeverity severity;
        
        // Constructor
        public MockLogMessage(String message, LogSeverity severity) {
            this.message = message;
            this.severity = severity;
        }
    }

    // The Log class must be mocked appropriately according to its actual implementation
    private class Log {
        private List<MockLogMessage> buffer = new List<MockLogMessage>();

        // Singleton instance getter method
        public static Log get() {
            return new Log();
        }

        // Add method which accepts a message and a severity
        public void add(String message, LogSeverity severity) {
            buffer.add(new MockLogMessage(message, severity));
        }

        // Publish method - in a real-world scenario, this would use EventBus.publish()
        // However, for the sake of this test, we will assume it simply clears the buffer
        public void publish() {
            // Simulate the publishing of events
            // In real-world, use EventBus.publish() and test with actual data retrieval after Test.stopTest()
            buffer.clear();
        }
    }
    
    @isTest
    static void testAddMessageWithSeverity() {
        // Arrange
        Log log = Log.get();
        String testMessage = 'Test message with severity';
        LogSeverity testSeverity = LogSeverity.ERROR;

        // Act
        log.add(testMessage, testSeverity);
        Integer bufferCountBeforePublish = log.buffer.size();

        Test.startTest();
        log.publish();
        Integer bufferCountAfterPublish = log.buffer.size();
        Test.stopTest();

        // Assert
        System.assertEquals(1, bufferCountBeforePublish, 'Buffer should have one message before publishing');
        System.assertEquals(0, bufferCountAfterPublish, 'Buffer should be empty after publishing');
    }

    // Additional test methods can be created to cover other scenarios
    // They would follow a similar pattern to the testAddMessageWithSeverity method.
}
