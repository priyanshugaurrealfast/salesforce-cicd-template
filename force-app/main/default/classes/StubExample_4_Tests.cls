
@isTest
public class StubExample_4_Tests {

    @isTest
    static void testSetGreetingWithValidInteger() {
        // Given
        StubExample instance = new StubExample();
        
        // When
        instance.setGreeting(123);

        // Then
        System.assertEquals('123', instance.getGreeting(), 'The greeting should be set to the string representation of the integer');
    }

    @isTest
    static void testSetGreetingWithNull() {
        // Given
        StubExample instance = new StubExample();
        Integer nullInt = null;
        
        // When
        instance.setGreeting(nullInt);

        // Then
        System.assertEquals(null, instance.getGreeting(), 'The greeting should be null when a null integer is passed');
    }
}
