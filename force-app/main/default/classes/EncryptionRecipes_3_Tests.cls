
@isTest
private class EncryptionRecipes_3_Tests {

    // Since DIGITAL_SIGNATURE_PRIVATE_KEY is a static variable and no DML operations or trigger interactions occur, no trigger bypass is necessary.

    @isTest
    static void testDigitalSignaturePrivateKeyNotNull() {
        // Assert that the DIGITAL_SIGNATURE_PRIVATE_KEY Blob is not null
        System.assertNotEquals(null, EncryptionRecipes.DIGITAL_SIGNATURE_PRIVATE_KEY,
            'The digital signature private key should not be null after class loading.');
    }
}
