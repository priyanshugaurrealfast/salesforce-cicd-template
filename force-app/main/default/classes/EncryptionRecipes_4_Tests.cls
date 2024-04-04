
@isTest
private class EncryptionRecipes_4_Tests {

    // Since we are only testing the static variable initialization, we do not require @testSetup data.

    @isTest
    static void testDigitalSignaturePublicKeyNotNull() {
        // Test to ensure the public key is initialized and not null
        Test.startTest();
        Blob publicKey = EncryptionRecipes.DIGITAL_SIGNATURE_PUBLIC_KEY;
        Test.stopTest();

        System.assertNotEquals(null, publicKey, 'The digital signature public key should not be null.');
    }
    
    // Since the public key is a static final variable, there would only be compile-time issues if it was not initialized correctly.
    // There are no further tests needed for runtime behavior as static final variables do not have runtime behavior that can change.
}
