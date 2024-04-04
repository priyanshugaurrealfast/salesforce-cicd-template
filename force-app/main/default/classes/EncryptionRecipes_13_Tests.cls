
@isTest
public class EncryptionRecipes_13_Tests {

    @testSetup
    static void setup() {
        // Since HMAC checks do not involve DML, no test data setup is required.
    }

    private static Blob validDataToCheck() {
        return Blob.valueOf('Test data');
    }

    private static Blob validHMAC() {
        return EncryptionRecipes.generateHMACSHA512Recipe(validDataToCheck());
    }

    // Happy path scenario
    @isTest
    static void testCheckHMACSHA512Recipe_WithValidHMAC() {
        Blob data = validDataToCheck();
        Blob hmac = validHMAC();
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            EncryptionRecipes.checkHMACSHA512Recipe(hmac, data);
        } catch (EncryptionRecipes.CryptographicException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        // Assert that no exception is thrown
        System.assert(!exceptionThrown, 'No exception should have been thrown for valid HMAC.');
    }

    // Sad path scenario
    @isTest
    static void testCheckHMACSHA512Recipe_WithInvalidHMAC() {
        Blob data = validDataToCheck();
        Blob hmac = validHMAC();
        Blob invalidData = Blob.valueOf('Invalid data');
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            EncryptionRecipes.checkHMACSHA512Recipe(hmac, invalidData);
        } catch (EncryptionRecipes.CryptographicException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'Expected an exception to be thrown for invalid HMAC.');
    }

    // Exceptional scenario
    @isTest
    static void testCheckHMACSHA512Recipe_WithNullValues() {
        Blob hmac = validHMAC();
        Boolean exceptionThrownForDataToCheck = false;
        Boolean exceptionThrownForHmac = false;

        Test.startTest();
        try {
            EncryptionRecipes.checkHMACSHA512Recipe(hmac, null);
        } catch (NullPointerException e) {
            exceptionThrownForDataToCheck = true;
        }

        try {
            EncryptionRecipes.checkHMACSHA512Recipe(null, validDataToCheck());
        } catch (NullPointerException e) {
            exceptionThrownForHmac = true;
        }
        Test.stopTest();

        System.assert(exceptionThrownForDataToCheck, 'Expected a NullPointerException to be thrown when dataToCheck is null.');
        System.assert(exceptionThrownForHmac, 'Expected a NullPointerException to be thrown when hmac is null.');
    }
}
