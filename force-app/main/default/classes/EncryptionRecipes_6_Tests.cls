
@isTest
public class EncryptionRecipes_6_Tests {
    @testSetup
    static void setup() {
        // Test data setup if required
    }
    
    @isTest
    static void testDecryptAES256WithManagedIVHappyPath() {
        // Arrange
        Blob dataToEncrypt = Blob.valueOf('Test data for encryption');
        Blob encryptedData = EncryptionRecipes.encryptAES256WithManagedIVRecipe(dataToEncrypt);
        
        // Act
        Blob decryptedData = EncryptionRecipes.decryptAES256WithManagedIVRecipe(encryptedData);
        
        // Assert
        System.assertEquals(dataToEncrypt.toString(), decryptedData.toString(), 'Decrypted data should match the original data.');
    }
    
    @isTest
    static void testDecryptAES256WithManagedIVNullData() {
        // Arrange
        Blob dataToDecrypt = null;
        
        // Act
        Exception ex = null;
        try {
            Blob decryptedData = EncryptionRecipes.decryptAES256WithManagedIVRecipe(dataToDecrypt);
        } catch (Exception e) {
            ex = e;
        }
        
        // Assert
        System.assertNotEquals(null, ex, 'Decrypting null should throw an exception.');
    }
    
    @isTest
    static void testDecryptAES256WithManagedIVInvalidData() {
        // Arrange
        Blob dataToDecrypt = Blob.valueOf('Invalid encrypted data');
        
        // Act
        Exception ex = null;
        try {
            Blob decryptedData = EncryptionRecipes.decryptAES256WithManagedIVRecipe(dataToDecrypt);
        } catch (Exception e) {
            ex = e;
        }

        // Assert
        System.assertNotEquals(null, ex, 'An exception should be thrown for invalid encrypted data.');
    }
}
