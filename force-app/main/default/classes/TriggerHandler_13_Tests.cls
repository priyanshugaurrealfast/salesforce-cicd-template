
@isTest
public class TriggerHandler_13_Tests {

    // Test method to verify the initial count is zero
    @isTest
    static void testInitialCount() {
        TriggerHandler.LoopCount loopCount = new TriggerHandler.LoopCount();
        
        // The count should be 0 initially
        System.assertEquals(0, loopCount.getCount(), 'The initial count should be 0.');
    }
    
    // Test method to verify the count increments correctly
    @isTest
    static void testIncrementCount() {
        TriggerHandler.LoopCount loopCount = new TriggerHandler.LoopCount();
        loopCount.increment();

        // The count should be 1 after incrementing once
        System.assertEquals(1, loopCount.getCount(), 'The count should increment to 1.');
    }
    
    // Test method to verify the count does not exceed the maximum when exceeded() is false
    @isTest
    static void testCountNotExceedMaximum() {
        TriggerHandler.LoopCount loopCount = new TriggerHandler.LoopCount(1); // Setting up the LoopCount maximum to 1
        loopCount.increment(); // Increment the count

        // The count should be 1 and not exceed the maximum
        System.assertEquals(1, loopCount.getCount(), 'The count should not exceed the maximum value of 1.');
    }
    
    // Test method to verify the count with no maximum limit
    @isTest
    static void testCountWithNoMaximum() {
        TriggerHandler.LoopCount loopCount = new TriggerHandler.LoopCount(-1); // Setting up no maximum limit by setting to -1

        // Increment count multiple times
        for(Integer i = 0; i < 10; i++) {
            loopCount.increment();
        }

        // The count should equal the number of increments since there's no limit
        System.assertEquals(10, loopCount.getCount(), 'The count should be equal to the number of increments when max is set to -1.');
    }
}
