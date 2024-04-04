
@isTest
public class EncryptionRecipes_9_Tests {

    @isTest
    static void testGenerateInitializationVector() {
        // Call the method to test
        Blob iv = EncryptionRecipes.generateInitializationVector();

        // Assert that the return value is not null
        System.assertNotEquals(null, iv, 'The initialization vector should not be null.');

        // Assert that the size of the Blob is 16 bytes (128 bits)
        System.assertEquals(16, iv.size(), 'The size of the initialization vector should be 16 bytes.');
    }
}
