
@isTest
private class EncryptionRecipes_17_Tests {

    @testSetup
    static void setup() {
        // Create test data that is required for the tests
        // As this is encryption-related, no specific Salesforce data setup is required
    }

    @isTest
    static void testDecryptAndCheckSignatureHappyPath() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create test data
        Blob dataToEncryptAndSign = Blob.valueOf('Test data to encrypt and sign');
        EncryptionRecipes.EncryptedAndSignedData encryptedAndSignedData =
            EncryptionRecipes.encryptAES256AndGenerateRSASHA512DigitalSignRecipe(dataToEncryptAndSign);

        // Decrypt and check signature
        Blob decryptedData = EncryptionRecipes.decryptAES256AndCheckRSASHA512DigitalSignRecipe(
            encryptedAndSignedData.signature,
            encryptedAndSignedData.encryptedData
        );

        // Asserts
        System.assertNotEquals(null, decryptedData, 'The decrypted data should not be null.');
        System.assertEquals(dataToEncryptAndSign.toString(), decryptedData.toString(), 'The decrypted data should match the original data.');
    }

    @isTest
    static void testDecryptAndCheckSignatureSadPath() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create test data
        Blob dataToEncryptAndSign = Blob.valueOf('Test data to encrypt and sign');
        Blob wrongSignature = Blob.valueOf('Incorrect signature');

        // Expect an exception due to wrong signature
        try {
            Blob decryptedData = EncryptionRecipes.decryptAES256AndCheckRSASHA512DigitalSignRecipe(
                wrongSignature,
                dataToEncryptAndSign
            );
            System.assert(false, 'A CryptographicException should have been thrown due to wrong signature.');
        } catch (EncryptionRecipes.CryptographicException e) {
            System.assertEquals('Wrong signature!', e.getMessage(), 'The exception message should indicate a wrong signature.');
        }
    }

    @isTest
    static void testDecryptAndCheckSignatureExceptionalScenario() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Pass null data which should lead to an exception
        try {
            Blob decryptedData = EncryptionRecipes.decryptAES256AndCheckRSASHA512DigitalSignRecipe(
                null,
                null
            );
            System.assert(false, 'An exception should have been thrown due to null parameters.');
        } catch (Exception e) {
            System.assert(e instanceof NullPointerException, 'The caught exception should be a NullPointerException.');
        }
    }
}
