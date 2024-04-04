
@isTest
private class AccountServiceLayer_1_Tests {
    
    // Test to make sure a valid string can be logged without any issue
    @isTest
    static void testJustWriteALogStatementWithValidString() {
        String validString = 'Test Log Statement';
        Test.startTest();
        AccountServiceLayer.justWriteALogStatement(validString);
        Test.stopTest();
        
        // Asserts
        String logResult = AccountServiceLayer.didExecuteMethod;
        System.assertEquals(validString, logResult, 'The log statement should be the same as the input string.');
    }
    
    // Test to ensure an empty string is handled correctly
    @isTest
    static void testJustWriteALogStatementWithEmptyString() {
        String emptyString = '';
        Test.startTest();
        AccountServiceLayer.justWriteALogStatement(emptyString);
        Test.stopTest();
        
        // Asserts
        String logResult = AccountServiceLayer.didExecuteMethod;
        System.assertEquals(emptyString, logResult, 'The log statement should be the same as the input string even if it is empty.');
    }
    
    // Test to ensure that passing null value does not cause a Null Pointer Exception
    @isTest
    static void testJustWriteALogStatementWithNullValue() {
        String nullString = null;
        Test.startTest();
        AccountServiceLayer.justWriteALogStatement(nullString);
        Test.stopTest();
        
        // Asserts
        String logResult = AccountServiceLayer.didExecuteMethod;
        System.assertEquals(nullString, logResult, 'The log statement should handle null values gracefully.');
    }
}
