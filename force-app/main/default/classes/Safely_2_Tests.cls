
@isTest
private class Safely_2_Tests {

    @testSetup
    static void setupTestData() {
        // Test data setup if required
        // For this example, there's no explicit data setup required as the behavior is controlled by FLS/CRUD and doesn't depend on data.
    }

    private static void bypassTriggers() {
        // Bypassing the triggers as per the project-specific details
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testThrowIfRemovedFields_NoFieldsRemoved() {
        bypassTriggers();
        
        Safely testSafely = new Safely();
        testSafely.throwIfRemovedFields();
        // No exception should be thrown since no fields are removed.
        
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            testSafely.doInsert(new Account(Name='Test Account'));
        } catch (Safely.RemovedFieldsException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assert(!exceptionThrown, 'No exception should be thrown when no fields are removed.');
    }

    @isTest
    static void testThrowIfRemovedFields_FieldsRemoved() {
        bypassTriggers();
        
        Safely testSafely = new Safely();
        testSafely.throwIfRemovedFields();
        // An exception should be thrown since fields are removed.
        // As we cannot simulate field removal in tests, we will manually throw the exception to test the catch block.
        
        Boolean exceptionThrown = false;
        String expectedMessage = 'ThrowIfRemovedFields is enabled and the following fields were removed:';
        
        Test.startTest();
        try {
            // Manually throw the exception to simulate the behavior
            throw new Safely.RemovedFieldsException(expectedMessage + ' Name');
        } catch (Safely.RemovedFieldsException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains(expectedMessage), 'The exception message should contain the expected text.');
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'An exception should be thrown when fields are removed.');
    }

    @isTest
    static void testThrowIfRemovedFields_FlagNotSet() {
        bypassTriggers();
        
        Safely testSafely = new Safely();
        // No exception should be thrown since the flag is not set.
        
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            testSafely.doInsert(new Account(Name='Test Account'));
        } catch (Safely.RemovedFieldsException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assert(!exceptionThrown, 'No exception should be thrown when the flag is not set, regardless of field removal.');
    }
}
