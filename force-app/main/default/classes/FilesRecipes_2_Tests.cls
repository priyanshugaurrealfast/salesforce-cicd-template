
@isTest
public class FilesRecipes_2_Tests {
    
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }
    
    @isTest
    static void testCreateFileAttachedToRecordHappyPath() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Blob fileContent = Blob.valueOf('Test File Content');
        String fileContentString = 'Test File Content'; // Use string for comparison
        String fileName = 'TestFile.txt';
        
        // Act
        Database.SaveResult saveResult = FilesRecipes.createFileAttachedToRecord(fileContent, testAccount.Id, fileName);
        
        // Assert
        System.assert(saveResult.isSuccess(), 'The file creation should be successful');
        ContentVersion createdContent = [SELECT Id, Title, VersionData FROM ContentVersion WHERE FirstPublishLocationId = :testAccount.Id LIMIT 1];
        System.assertEquals(fileName, createdContent.Title, 'The file title should match the provided file name');
        System.assertEquals(fileContentString, createdContent.VersionData.toString(), 'The file content should match the provided file content');
    }
    
    @isTest
    static void testCreateFileAttachedToRecordWithNullBlob() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        String fileName = 'TestFile.txt';
        
        // Act
        Database.SaveResult saveResult = FilesRecipes.createFileAttachedToRecord(null, testAccount.Id, fileName);
        
        // Assert
        System.assert(!saveResult.isSuccess(), 'The file creation should fail due to null Blob content');
    }
}
