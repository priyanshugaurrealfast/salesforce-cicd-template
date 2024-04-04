
@isTest
private class EncryptionRecipes_10_Tests {
    
    // Tests the generation of SHA-512 hash with a valid input Blob
    @isTest
    static void testGenerateSHA512HashRecipeWithNonNullInput() {
        // Given
        Blob dataToHash = Blob.valueOf('Test data');
        
        // When
        Blob hash = EncryptionRecipes.generateSHA512HashRecipe(dataToHash);
        
        // Then
        System.assertNotEquals(null, hash, 'The hash should not be null.');
        System.assertEquals(64, hash.size(), 'SHA-512 hash should be 64 bytes.');
    }

    // Tests the generation of SHA-512 hash with an empty input Blob
    @isTest
    static void testGenerateSHA512HashRecipeWithEmptyInput() {
        // Given
        Blob dataToHash = Blob.valueOf('');
        
        // When
        Blob hash = EncryptionRecipes.generateSHA512HashRecipe(dataToHash);
        
        // Then
        System.assertNotEquals(null, hash, 'The hash for an empty string should not be null.');
        System.assertEquals(64, hash.size(), 'SHA-512 hash should be 64 bytes.');
    }

    // Tests the generation of SHA-512 hash with a null input Blob
    // Expecting a NullPointerException to be thrown
    @isTest
    static void testGenerateSHA512HashRecipeWithNullInput() {
        try {
            // Given
            Blob dataToHash = null;
            
            // When
            Blob hash = EncryptionRecipes.generateSHA512HashRecipe(dataToHash);
            
            // Then
            System.assert(false, 'Method did not throw an exception as expected.');
        } catch (NullPointerException e) {
            // Expected exception caught. Test passes.
        }
    }
}
