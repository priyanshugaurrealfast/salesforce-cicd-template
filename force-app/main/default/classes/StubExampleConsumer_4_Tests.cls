
// Assuming this interface is defined outside of the test class in the shared scope.
public interface StubExample {
    Boolean getIsTrue();
    String getGreeting();
    void setGreeting(String greeting);
    void setGreeting(Integer someInt);
}

// This is the test class.
@isTest
private class StubExampleConsumer_4_Tests {

    // Mock class for StubExample
    private class StubExampleMock implements StubExample {
        public Boolean isSetGreetingCalled = false;
        public Integer lastIntValue;

        public Boolean getIsTrue() {
            return true;
        }

        public String getGreeting() {
            return 'Hello';
        }

        public void setGreeting(String greeting) {
            // Do nothing, this is a mock
        }

        public void setGreeting(Integer someInt) {
            isSetGreetingCalled = true;
            lastIntValue = someInt;
        }
    }

    @isTest
    static void testSetGreetingWithValidInteger() {
        StubExampleMock mock = new StubExampleMock();
        StubExampleConsumer consumer = new StubExampleConsumer(mock); // Pass the mock that implements the interface
        Integer testValue = 10;

        Test.startTest();
        consumer.setGreeting(testValue); // Call the method with a valid integer
        Test.stopTest();

        // Assertions to verify that setGreeting was called with the correct integer value
        System.assert(mock.isSetGreetingCalled, 'The setGreeting(Integer) method should have been called on the stub.');
        System.assertEquals(testValue, mock.lastIntValue, 'The integer passed to setGreeting should match the test value.');
    }
}
