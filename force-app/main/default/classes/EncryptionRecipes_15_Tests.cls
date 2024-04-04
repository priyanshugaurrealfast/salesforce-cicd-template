
@isTest
private class EncryptionRecipes_15_Tests {

    // Test setup for creating necessary test data
    @testSetup
    static void setup() {
        // No specific setup required for these tests since we are testing static methods not involving DML or SOQL
    }
    
    // Helper method to generate a valid signature for test data
    private static Blob generateValidSignature(Blob data) {
        return Crypto.sign(
            'RSA-SHA512',
            data,
            EncryptionRecipes.DIGITAL_SIGNATURE_PRIVATE_KEY
        );
    }

    // Test method for happy path scenario
    @isTest
    static void testCheckRSASHA512DigitalSignatureRecipe_ValidSignature() {
        Blob data = Blob.valueOf('Test Data');
        Blob validSignature = generateValidSignature(data);

        Test.startTest();
        try {
            EncryptionRecipes.checkRSASHA512DigitalSignatureRecipe(validSignature, data);
        } catch (EncryptionRecipes.CryptographicException e) {
            System.assert(false, 'Valid signature threw CryptographicException');
        }
        Test.stopTest();

        System.assert(true, 'Valid signature should not throw an exception');
    }

    // Test method for invalid signature scenario
    @isTest
    static void testCheckRSASHA512DigitalSignatureRecipe_InvalidSignature() {
        Blob data = Blob.valueOf('Test Data');
        Blob validSignature = generateValidSignature(data);
        // Alter the signature to make it invalid
        Blob invalidSignature = Blob.valueOf('InvalidSignature');

        Test.startTest();
        Boolean caughtException = false;
        try {
            EncryptionRecipes.checkRSASHA512DigitalSignatureRecipe(invalidSignature, data);
        } catch (EncryptionRecipes.CryptographicException e) {
            caughtException = true;
        }
        Test.stopTest();

        System.assert(caughtException, 'Invalid signature should throw CryptographicException');
    }

    // Test method for invalid data scenario
    @isTest
    static void testCheckRSASHA512DigitalSignatureRecipe_InvalidData() {
        Blob data = Blob.valueOf('Test Data');
        Blob validSignature = generateValidSignature(data);
        // Alter the data to make it invalid
        Blob invalidData = Blob.valueOf('Invalid Data');

        Test.startTest();
        Boolean caughtException = false;
        try {
            EncryptionRecipes.checkRSASHA512DigitalSignatureRecipe(validSignature, invalidData);
        } catch (EncryptionRecipes.CryptographicException e) {
            caughtException = true;
        }
        Test.stopTest();

        System.assert(caughtException, 'Invalid data should throw CryptographicException');
    }

    // Test method for null signature scenario
    @isTest
    static void testCheckRSASHA512DigitalSignatureRecipe_NullSignature() {
        Blob data = Blob.valueOf('Test Data');
        Blob nullSignature = null;

        Test.startTest();
        Boolean caughtException = false;
        try {
            EncryptionRecipes.checkRSASHA512DigitalSignatureRecipe(nullSignature, data);
        } catch (Exception e) {
            caughtException = true;
        }
        Test.stopTest();

        System.assert(caughtException, 'Null signature should throw an exception');
    }

    // Test method for null data scenario
    @isTest
    static void testCheckRSASHA512DigitalSignatureRecipe_NullData() {
        Blob validSignature = generateValidSignature(Blob.valueOf('Test Data'));
        Blob nullData = null;

        Test.startTest();
        Boolean caughtException = false;
        try {
            EncryptionRecipes.checkRSASHA512DigitalSignatureRecipe(validSignature, nullData);
        } catch (Exception e) {
            caughtException = true;
        }
        Test.stopTest();

        System.assert(caughtException, 'Null data should throw an exception');
    }
}
