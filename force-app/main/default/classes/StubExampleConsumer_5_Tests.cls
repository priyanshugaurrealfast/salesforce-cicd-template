
@isTest
private class StubExampleConsumer_5_Tests {

    // Assuming StubExample is an interface defined in the codebase
    // and it has methods like getIsTrue(), getGreeting(), and setGreeting(String)
    
    // Mock class implementing the StubExample interface
    private class StubExampleMock implements StubExample {
        private String lastGreetingSet;
        
        public Boolean getIsTrue() {
            return true;
        }

        public String getGreeting() {
            return lastGreetingSet;
        }

        public void setGreeting(String greeting) {
            // Store the last greeting set for verification
            this.lastGreetingSet = greeting;
        }
        
        // Helper method to get the last greeting set for assertion
        public String getLastGreetingSet() {
            return this.lastGreetingSet;
        }
    }

    @isTest
    static void testSetGreetingWithTrue() {
        StubExampleMock mock = new StubExampleMock();
        StubExampleConsumer consumer = new StubExampleConsumer(mock); // Passing the mock object directly

        Test.startTest();
        consumer.setGreeting(true);
        Test.stopTest();

        // Assert that the setGreeting method was called with 'true' as a String
        System.assertEquals('true', mock.getLastGreetingSet(), 'The greeting was not set correctly for true.');
    }

    @isTest
    static void testSetGreetingWithFalse() {
        StubExampleMock mock = new StubExampleMock();
        StubExampleConsumer consumer = new StubExampleConsumer(mock); // Passing the mock object directly

        Test.startTest();
        consumer.setGreeting(false);
        Test.stopTest();

        // Assert that the setGreeting method was called with 'false' as a String
        System.assertEquals('false', mock.getLastGreetingSet(), 'The greeting was not set correctly for false.');
    }
}
