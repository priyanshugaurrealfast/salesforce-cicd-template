
@isTest
private class ScheduledApexDemo_1_Tests {

    // Since the method runAtMidnight does not operate on any SObjects,
    // there is no need for a @testSetup method to create test data.

    // This test ensures that the counter is incremented after running the runAtMidnight method.
    @isTest
    static void testRunAtMidnightIncrementsCounter() {
        // Instantiate the ScheduledApexDemo class
        ScheduledApexDemo demo = new ScheduledApexDemo();

        // Ensure the counter is at its initial state
        Test.startTest();
        Integer initialCounter = demo.counter;
        demo.runAtMidnight(); // Execute the method
        Test.stopTest();

        // Assert that the counter has been incremented by 1
        System.assertEquals(initialCounter + 1, demo.counter, 'The counter should be incremented.');
    }

    // There are no other scenarios since the runAtMidnight method logic is simple, and there are no sad or exceptional paths.
}
