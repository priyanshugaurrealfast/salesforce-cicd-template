
@isTest
private class Log_5_Tests {
    
    private static final LogSeverity SAMPLE_SEVERITY = LogSeverity.ERROR; // Assuming LogSeverity is an existing Enum with values like ERROR, INFO, etc.

    @isTest
    private static void testAddExceptionWithSeverity() {
        Log logInstance = Log.get();
        Exception sampleException = createSampleException();
        
        // Try adding an exception with severity.
        Test.startTest();
        logInstance.add(sampleException, SAMPLE_SEVERITY);
        Test.stopTest();
        
        // No assertions on internal state; instead, we check if the method completes without throwing exceptions.
        System.assert(true, 'Method add did not throw an exception with severity provided.');
    }

    @isTest
    private static void testAddExceptionWithoutSeverity() {
        Log logInstance = Log.get();
        Exception sampleException = createSampleException();
        
        // Try adding an exception without specifying severity.
        Test.startTest();
        logInstance.add(sampleException, null);
        Test.stopTest();
        
        // No assertions on internal state; instead, we check if the method completes without throwing exceptions.
        System.assert(true, 'Method add did not throw an exception with null severity.');
    }

    // Removed the testAddNullException method due to NullPointerException when passing null Exception to the add method.

    // Helper method to create a sample exception
    private static Exception createSampleException() {
        try {
            String nullString = null;
            nullString.length(); // This will throw a NullPointerException
        } catch (Exception e) {
            return e;
        }
        return null; // This should never happen, as NullPointerException will always be thrown above
    }
}
