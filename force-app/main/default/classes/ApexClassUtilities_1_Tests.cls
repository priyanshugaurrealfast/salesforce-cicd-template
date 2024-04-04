
@isTest
private class ApexClassUtilities_1_Tests {
    
    @isTest
    static void testGetGroupFromClassBodyWithGroupAnnotation() {
        String classBodyWithGroup = '/**\n * @group Test Group\n */';
        ApexClass mockClassWithGroup = new ApexClass(Name='MockClassWithGroup', Body=classBodyWithGroup);
        
        // Call the method we're testing
        String extractedGroup = ApexClassUtilities.getGroupFromClassBody(mockClassWithGroup);
        
        // Assert the result was as expected
        System.assertEquals('Test Group', extractedGroup, 'The group name should be extracted correctly from the class with annotation.');
    }
    
    @isTest
    static void testGetGroupFromClassBodyWithoutGroupAnnotation() {
        String classBodyWithoutGroup = '/**\n * This class has no group.\n */';
        ApexClass mockClassWithoutGroup = new ApexClass(Name='MockClassWithoutGroup', Body=classBodyWithoutGroup);
        
        // Call the method we're testing
        String extractedGroup = ApexClassUtilities.getGroupFromClassBody(mockClassWithoutGroup);
        
        // Assert the result was as expected
        System.assertEquals('', extractedGroup, 'Since there is no group annotation, the result should be an empty string.');
    }
    
    @isTest
    static void testGetGroupFromClassBodyWithNullClass() {
        // Test that the method handles a null ApexClass gracefully
        Boolean didThrowException = false;
        try {
            String extractedGroup = ApexClassUtilities.getGroupFromClassBody(null);
        } catch (Exception e) {
            didThrowException = true;
        }
        
        // Assert that an exception was thrown
        System.assert(didThrowException, 'Passing a null class should throw an exception.');
    }
}
