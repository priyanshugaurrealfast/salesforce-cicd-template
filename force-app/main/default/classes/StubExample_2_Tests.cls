
@isTest
private class StubExample_2_Tests {

    @testSetup
    static void setup() {
        // As the getGreeting method does not interact with stored data, test setup is not required.
    }

    @isTest
    static void testGetGreetingWithDefaultValue() {
        StubExample stubExample = new StubExample();
        String expectedGreeting = 'hello';
        String actualGreeting = stubExample.getGreeting();
        
        System.assertEquals(expectedGreeting, actualGreeting, 'The default greeting should be "hello".');
    }

    @isTest
    static void testGetGreetingAfterSettingString() {
        StubExample stubExample = new StubExample();
        String newGreeting = 'hi';
        stubExample.setGreeting(newGreeting);
        
        String actualGreeting = stubExample.getGreeting();
        System.assertEquals(newGreeting, actualGreeting, 'The greeting should be updated to "hi".');
    }

    @isTest
    static void testGetGreetingAfterSettingInteger() {
        StubExample stubExample = new StubExample();
        Integer newGreetingInt = 123;
        stubExample.setGreeting(newGreetingInt);
        
        String expectedGreeting = '123';
        String actualGreeting = stubExample.getGreeting();
        System.assertEquals(expectedGreeting, actualGreeting, 'The greeting should be converted to "123".');
    }
}
