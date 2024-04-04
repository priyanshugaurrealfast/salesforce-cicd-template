
@isTest
private class EncryptionRecipes_8_Tests {

    private static Blob generateTestBlob(String data) {
        return Blob.valueOf(data);
    }

    @testSetup
    static void setup() {
        // Test setup code can be put here if needed in future
    }

    @isTest
    static void testDecryptAES256RecipeWithValidData() {
        // Disable triggers as per instructions
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Prepare test data
        Blob testData = generateTestBlob('Test data for encryption');
        Blob initializationVector = EncryptionRecipes.generateInitializationVector();
        Blob encryptedData = EncryptionRecipes.encryptAES256Recipe(testData, initializationVector);

        // Call target method with valid data
        Blob decryptedData = EncryptionRecipes.decryptAES256Recipe(encryptedData);

        // Assertions
        System.assertNotEquals(null, decryptedData, 'Decrypted data should not be null');
        System.assertEquals(testData.toString(), decryptedData.toString(), 'Decrypted data should match original data');
    }

    @isTest
    static void testDecryptAES256RecipeWithNullData() {
        // Disable triggers as per instructions
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Expect an exception to be thrown
        Boolean exceptionThrown = false;
        try {
            Blob decryptedData = EncryptionRecipes.decryptAES256Recipe(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        // Assertions
        System.assert(exceptionThrown, 'Passing null to decryptAES256Recipe should throw an exception');
    }

    @isTest
    static void testDecryptAES256RecipeWithMalformedData() {
        // Disable triggers as per instructions
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Prepare malformed data (Blob with a proper initialization vector but corrupted encrypted data)
        Blob testData = generateTestBlob('Malformed data');
        Blob initializationVector = EncryptionRecipes.generateInitializationVector();
        Blob encryptedData = EncryptionRecipes.encryptAES256Recipe(testData, initializationVector);
        // Corrupt the encrypted data by altering it
        String encryptedDataHex = EncodingUtil.convertToHex(encryptedData);
        String corruptedEncryptedDataHex = encryptedDataHex.substring(0, encryptedDataHex.length() - 2) + '00';
        Blob corruptedEncryptedData = EncodingUtil.convertFromHex(corruptedEncryptedDataHex);

        // Expect an exception to be thrown
        Boolean exceptionThrown = false;
        try {
            Blob decryptedData = EncryptionRecipes.decryptAES256Recipe(corruptedEncryptedData);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        // Assertions
        System.assert(exceptionThrown, 'Passing malformed data to decryptAES256Recipe should throw an exception');
    }
}
