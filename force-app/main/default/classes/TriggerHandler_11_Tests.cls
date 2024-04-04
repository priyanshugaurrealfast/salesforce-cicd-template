
@isTest
public class TriggerHandler_11_Tests {

    @isTest
    static void testLoopCountNotExceeded() {
        // Arrange
        TriggerHandler.LoopCount testLoopCount = createLoopCount(2);
        
        // Act
        testLoopCount.increment(); // This should not exceed the loop count

        // Assert
        System.assertEquals(false, testLoopCount.exceeded(), 'The loop count should not be exceeded when it is below the max.');
    }

    @isTest
    static void testLoopCountExceeded() {
        // Arrange
        TriggerHandler.LoopCount testLoopCount = createLoopCount(1);

        // Act
        testLoopCount.increment(); // Increment once, this should reach the max
        Boolean exceeded = testLoopCount.increment(); // Increment twice, this should exceed the max

        // Assert
        System.assertEquals(true, exceeded, 'The loop count should be exceeded when it goes beyond the max.');
    }

    @isTest
    static void testLoopCountNotExceededWithNegativeMax() {
        // Arrange
        TriggerHandler.LoopCount testLoopCount = createLoopCount(-1);

        // Act
        testLoopCount.increment(); // Increment once
        testLoopCount.increment(); // Increment twice, should not matter due to negative max

        // Assert
        System.assertEquals(false, testLoopCount.exceeded(), 'The loop count should never be exceeded with a negative max.');
    }

    // Helper method to create a LoopCount instance for the tests
    private static TriggerHandler.LoopCount createLoopCount(Integer max) {
        TriggerHandler handler = new TriggerHandler();
        return handler.new LoopCount(max);
    }
}
