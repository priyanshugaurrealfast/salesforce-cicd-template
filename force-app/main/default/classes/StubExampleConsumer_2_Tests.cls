
@isTest
private class StubExampleConsumer_2_Tests {
    
    // Happy Path - Stub returns a valid greeting string.
    @isTest
    static void testGetGreetingHappyPath() {
        // Arrange
        StubExample mockStub = new StubExampleMock();
        ((StubExampleMock)mockStub).setGreeting('Hello, world!');
        StubExampleConsumer consumer = new StubExampleConsumer(mockStub);

        // Act
        String result = consumer.getGreeting();

        // Assert
        System.assertEquals('Hello, world!', result, 'Expected greeting was not returned by getGreeting().');
    }

    // Sad Path - Stub returns null.
    @isTest
    static void testGetGreetingSadPath() {
        // Arrange
        StubExample mockStub = new StubExampleMock();
        ((StubExampleMock)mockStub).setGreeting(null);
        StubExampleConsumer consumer = new StubExampleConsumer(mockStub);

        // Act
        String result = consumer.getGreeting();

        // Assert
        System.assertEquals(null, result, 'Expected null was not returned by getGreeting().');
    }

    // Mock implementation for StubExample interface
    private class StubExampleMock implements StubExample {
        private String greeting;

        public StubExampleMock() {
        }

        public String getGreeting() {
            return this.greeting;
        }

        public void setGreeting(String greeting) {
            this.greeting = greeting;
        }

        public void setGreeting(Integer someInt) {
            // Not used in this test
        }

        public void setGreeting(Boolean someBoolean) {
            // Not used in this test
        }

        public Boolean getIsTrue() {
            // Not used in this test
            return true;
        }
    }
}
