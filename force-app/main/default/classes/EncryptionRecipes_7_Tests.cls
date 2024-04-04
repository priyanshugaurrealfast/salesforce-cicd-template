
@isTest
private class EncryptionRecipes_7_Tests {

    @testSetup
    static void setup() {
        // No test data setup required as the method does not interact with SObjects
    }

    @isTest
    static void testEncryptAES256WithValidInput() {
        // Happy Path
        Blob dataToEncrypt = Blob.valueOf('Test data for encryption');
        Blob initializationVector = Crypto.generateAesKey(128); // 16 bytes AES key generation for IV
        
        Blob encryptedData = EncryptionRecipes.encryptAES256Recipe(dataToEncrypt, initializationVector);
        
        System.assertNotEquals(null, encryptedData, 'The encrypted data should not be null.');
        System.assert(encryptedData.size() > 0, 'The encrypted data should not be empty.');
    }

    @isTest
    static void testEncryptAES256WithNullData() {
        // Sad Path: null dataToEncrypt
        Blob initializationVector = Crypto.generateAesKey(128);
        
        try {
            Blob encryptedData = EncryptionRecipes.encryptAES256Recipe(null, initializationVector);
            System.assert(false, 'Expected an exception when data to encrypt is null.');
        } catch (Exception e) {
            // Exception is expected, no need to assert the message
        }
    }

    @isTest
    static void testEncryptAES256WithNullInitializationVector() {
        // Sad Path: null initializationVector
        Blob dataToEncrypt = Blob.valueOf('Test data for encryption');
        
        try {
            Blob encryptedData = EncryptionRecipes.encryptAES256Recipe(dataToEncrypt, null);
            System.assert(false, 'Expected an exception when initialization vector is null.');
        } catch (Exception e) {
            // Exception is expected, no need to assert the message
        }
    }

    @isTest
    static void testEncryptAES256WithInvalidInitializationVectorSize() {
        // Exception Scenario: Invalid Initialization Vector size
        Blob dataToEncrypt = Blob.valueOf('Test data for encryption');
        Blob invalidInitializationVector = Blob.valueOf('123'); // Invalid size
        
        Boolean exceptionThrown = false;
        try {
            Blob encryptedData = EncryptionRecipes.encryptAES256Recipe(dataToEncrypt, invalidInitializationVector);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'Expected an exception for an invalid initialization vector size.');
    }
}
