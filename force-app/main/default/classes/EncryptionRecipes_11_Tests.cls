
@isTest
private class EncryptionRecipes_11_Tests {
    
    // Utility method to generate a Blob from a String for convenience
    private static Blob blobFromString(String data) {
        return Blob.valueOf(data);
    }
    
    // Happy Path: When the hash matches the computed hash for the data
    @isTest
    static void testCheckSHA512HashRecipeWithMatchingHash() {
        // Setup test data
        Blob dataToCheck = blobFromString('Test data for SHA512 hash');
        Blob correctHash = EncryptionRecipes.generateSHA512HashRecipe(dataToCheck);
        
        // Perform test
        Test.startTest();
        try {
            EncryptionRecipes.checkSHA512HashRecipe(correctHash, dataToCheck);
        } catch (EncryptionRecipes.CryptographicException e) {
            System.assert(false, 'Exception should not have been thrown');
        }
        Test.stopTest();
        
        // Assertions
        System.assert(true, 'The hash matches the computed hash as expected.');
    }
    
    // Sad Path: When the hash does not match the computed hash for the data
    @isTest
    static void testCheckSHA512HashRecipeWithMismatchingHash() {
        // Setup test data
        Blob dataToCheck = blobFromString('Test data for SHA512 hash');
        Blob incorrectHash = blobFromString('Incorrect hash');
        
        Boolean exceptionThrown = false;
        
        // Perform test
        Test.startTest();
        try {
            EncryptionRecipes.checkSHA512HashRecipe(incorrectHash, dataToCheck);
        } catch (EncryptionRecipes.CryptographicException e) {
            exceptionThrown = true;
            // Assertions
            System.assertEquals('Wrong hash!', e.getMessage(), 'Exception message should match expected text.');
        }
        Test.stopTest();
        
        // Verify that an exception was thrown
        System.assert(exceptionThrown, 'An exception should have been thrown due to mismatch hash.');
    }
    
    // Exceptional Scenario: When invalid arguments are passed
    @isTest
    static void testCheckSHA512HashRecipeWithInvalidArguments() {
        // Test with null data to check
        Boolean exceptionThrownForNullData = false;
        try {
            EncryptionRecipes.checkSHA512HashRecipe(blobFromString('Some hash'), null);
        } catch (Exception e) {
            exceptionThrownForNullData = true;
        }
        System.assert(exceptionThrownForNullData, 'An exception should have been thrown for null data to check.');
        
        // Test with null hash
        Boolean exceptionThrownForNullHash = false;
        try {
            EncryptionRecipes.checkSHA512HashRecipe(null, blobFromString('Some data'));
        } catch (Exception e) {
            exceptionThrownForNullHash = true;
        }
        System.assert(exceptionThrownForNullHash, 'An exception should have been thrown for null hash.');
    }
}
