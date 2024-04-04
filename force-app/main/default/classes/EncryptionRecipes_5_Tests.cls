
@isTest
public class EncryptionRecipes_5_Tests {
    
    @isTest
    static void testEncryptNonNullData() {
        Blob dataToEncrypt = Blob.valueOf('Test data to encrypt');
        
        Test.startTest();
        Blob encryptedData = EncryptionRecipes.encryptAES256WithManagedIVRecipe(dataToEncrypt);
        Test.stopTest();
        
        System.assertNotEquals(null, encryptedData, 'Encrypted data should not be null.');
        System.assertNotEquals(dataToEncrypt, encryptedData, 'Encrypted data should not match the original data.');
    }

    @isTest
    static void testEncryptNullData() {
        Blob dataToEncrypt = null;
        Boolean isExceptionThrown = false;

        Test.startTest();
        try {
            Blob encryptedData = EncryptionRecipes.encryptAES256WithManagedIVRecipe(dataToEncrypt);
        } catch (NullPointerException e) {
            isExceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, isExceptionThrown, 'Encrypting null data should throw NullPointerException.');
    }
}
