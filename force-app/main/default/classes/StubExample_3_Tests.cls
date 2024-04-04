
@isTest
private class StubExample_3_Tests {

    @isTest
    static void testSetGreetingWithNonNullValue() {
        // Initialize the class instance
        StubExample stubExample = new StubExample();
        
        // Call method with a valid string
        stubExample.setGreeting('Hi there!');
        
        // Assertions
        System.assertEquals('Hi there!', stubExample.getGreeting(), 'The greeting was not set correctly.');
    }

    @isTest
    static void testSetGreetingWithNullValue() {
        // Initialize the class instance
        StubExample stubExample = new StubExample();
        
        // Call method with null, casting to String to avoid ambiguity
        stubExample.setGreeting((String)null);
        
        // Assertions
        System.assertEquals(null, stubExample.getGreeting(), 'The greeting should be updated to null.');
    }
}
