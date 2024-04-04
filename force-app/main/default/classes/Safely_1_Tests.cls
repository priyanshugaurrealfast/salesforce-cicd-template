
@isTest
private class Safely_1_Tests {

    @testSetup
    static void setup() {
        // Setup test data if necessary
        // In this case, no data setup is required for the allOrNothing test.
    }

    @isTest
    static void testAllOrNothingFlagSet() {
        // Test to ensure `allOrNothing` flag is set correctly
        Safely safelyInstance = new Safely();
        safelyInstance.allOrNothing();
        System.assertEquals(true, safelyInstance.allOrNothing, 'The allOrNothing flag should be true');
    }

    @isTest
    static void testAllOrNothingMethodChaining() {
        // Test to ensure method chaining is possible after calling `allOrNothing()`
        Safely safelyInstance = new Safely();
        Safely chainedInstance = safelyInstance.allOrNothing();
        System.assertNotEquals(null, chainedInstance, 'The method allOrNothing() should return an instance of Safely');
        System.assertEquals(safelyInstance, chainedInstance, 'The returned instance should be the same as the one on which the method was called');
    }

    // Additional test methods could be added if needed for other scenarios
}
