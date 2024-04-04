
@isTest
private class EncryptionRecipes_16_Tests {

    // Utility method to bypass triggers
    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    // Test method for happy path scenario
    @isTest
    static void testEncryptAES256AndGenerateRSASHA512DigitalSignRecipeHappyPath() {
        bypassTriggers();
        
        // Setup test data
        Blob dataToEncryptAndSign = Blob.valueOf('Test data for encryption and signing');
        
        // Perform test
        Test.startTest();
        EncryptionRecipes.EncryptedAndSignedData result = EncryptionRecipes.encryptAES256AndGenerateRSASHA512DigitalSignRecipe(dataToEncryptAndSign);
        Test.stopTest();
        
        // Verify the results
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertNotEquals(null, result.encryptedData, 'The encryptedData should not be null');
        System.assertNotEquals(null, result.signature, 'The signature should not be null');
    }
    
    // Test method for sad path scenario
    @isTest
    static void testEncryptAES256AndGenerateRSASHA512DigitalSignRecipeSadPath() {
        bypassTriggers();
        
        // Setup test data
        Blob dataToEncryptAndSign = null;
        
        // Expected exception
        Boolean didThrowException = false;
        
        try {
            // Perform test
            Test.startTest();
            EncryptionRecipes.encryptAES256AndGenerateRSASHA512DigitalSignRecipe(dataToEncryptAndSign);
            Test.stopTest();
        } catch (NullPointerException e) {
            didThrowException = true;
        }
        
        // Verify that a NullPointerException was thrown
        System.assertEquals(true, didThrowException, 'A NullPointerException should have been thrown');
    }
}
