
@isTest
private class EncryptionRecipes_14_Tests {
    
    // Test setup to create data
    @testSetup
    static void setup() {
        // Test setup code, if needed, goes here...
    }
    
    // Test for the happy path scenario
    @isTest
    static void testGenerateRSASHA512DigitalSignatureRecipe() {
        Blob dataToSign = Blob.valueOf('Test data for signature');
        Test.startTest();
        Blob signature = EncryptionRecipes.generateRSASHA512DigitalSignatureRecipe(dataToSign);
        Test.stopTest();
        
        System.assertNotEquals(null, signature, 'Signature should not be null');
        System.assertNotEquals(Blob.valueOf(''), signature, 'Signature should not be an empty Blob');
    }
    
    // Test for the sad path scenario: Signing a null Blob
    @isTest
    static void testGenerateRSASHA512DigitalSignatureRecipeWithNullData() {
        Blob dataToSign = null;
        Boolean exceptionThrown = false;
        
        try {
            Test.startTest();
            Blob signature = EncryptionRecipes.generateRSASHA512DigitalSignatureRecipe(dataToSign);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            // We expect an exception message that indicates a null argument
            System.assert(e.getMessage().contains('Argument cannot be null'), 'Expected null argument exception');
        }
        
        System.assert(exceptionThrown, 'Method did not throw an exception when signing null data');
    }
    
    // No exceptional scenario test required as per the instructions
}
