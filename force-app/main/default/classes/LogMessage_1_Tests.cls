
@isTest
public class LogMessage_1_Tests {

    @testSetup
    static void makeTestData() {
        // No pre-existing data needed for these tests
    }

    @isTest
    static void testToEventHappyPath() {
        // Arrange
        LogMessage logMsg = new LogMessage('Test message');
        
        // Act
        Log__e event = logMsg.toEvent();

        // Assert
        System.assertNotEquals(null, event, 'Event should not be null.');
        System.assertEquals('Test message', event.Log_Message__c, 'Log message should match.');
    }

    @isTest
    static void testToEventWithNullMessage() {
        // Arrange
        LogMessage logMsg = new LogMessage((String)null);

        // Act
        Log__e event = logMsg.toEvent();

        // Assert
        System.assertNotEquals(null, event, 'Event should not be null.');
        System.assertEquals(null, event.Log_Message__c, 'Log message should be null.');
    }

    @isTest
    static void testToEventWithExceptionMessage() {
        // Arrange
        Exception caughtException;
        try {
            String s = null;
            s.length(); // This line will throw a NullPointerException
        } catch (Exception e) {
            caughtException = e;
        }
        LogMessage logMsg = new LogMessage(caughtException);

        // Act
        Log__e event = logMsg.toEvent();

        // Assert
        System.assertNotEquals(null, event, 'Event should not be null.');
        System.assert(event.Log_Message__c.contains('Exception:'), 'Log message should contain "Exception:" prefix.');
    }
}
