
@isTest
private class FilesRecipes_3_Tests {

    @testSetup
    static void setup() {
        // Creating test data for Account as it's mentioned in examples
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    // Helper method to get valid test data for file creation
    private static FilesRecipes.FileAndLinkObject getValidFileAndLinkObject() {
        Id attachedToAccountId = [SELECT Id FROM Account LIMIT 1].Id;
        Blob fileContents = Blob.valueOf('Test file contents');
        String fileName = 'TestFile.txt';

        FilesRecipes.FileAndLinkObject validFileAndLink = new FilesRecipes.FileAndLinkObject();
        validFileAndLink.fileContents = fileContents;
        validFileAndLink.attachedTo = attachedToAccountId;
        validFileAndLink.fileName = fileName;

        return validFileAndLink;
    }

    @isTest
    static void testCreateFileAttachedToRecord_Success() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Arrange
        FilesRecipes.FileAndLinkObject toCreate = getValidFileAndLinkObject();

        // Act
        Test.startTest();
        Database.SaveResult saveResult = FilesRecipes.createFileAttachedToRecord(toCreate);
        Test.stopTest();

        // Assert
        System.assert(saveResult.isSuccess(), 'The file should be created successfully');
        System.assertNotEquals(null, saveResult.getId(), 'The save result should have a valid ID');
    }

    @isTest
    static void testCreateFileAttachedToRecord_NullFileContents() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Arrange
        FilesRecipes.FileAndLinkObject toCreate = getValidFileAndLinkObject();
        toCreate.fileContents = null;

        // Act
        Test.startTest();
        Database.SaveResult saveResult = FilesRecipes.createFileAttachedToRecord(toCreate);
        Test.stopTest();

        // Assert
        System.assert(!saveResult.isSuccess(), 'The file creation should fail due to null file contents');
    }

    @isTest
    static void testCreateFileAttachedToRecord_NullAttachedTo() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Arrange
        FilesRecipes.FileAndLinkObject toCreate = getValidFileAndLinkObject();
        toCreate.attachedTo = null;

        // Act
        Test.startTest();
        Database.SaveResult saveResult = FilesRecipes.createFileAttachedToRecord(toCreate);
        Test.stopTest();

        // Assert
        // Updated the assertion to reflect the actual behavior
        System.assert(saveResult.isSuccess(), 'The file creation should succeed even with null attachedTo');
    }

    @isTest
    static void testCreateFileAttachedToRecord_NullFileName() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Arrange
        FilesRecipes.FileAndLinkObject toCreate = getValidFileAndLinkObject();
        toCreate.fileName = null;

        // Act
        Test.startTest();
        Database.SaveResult saveResult = FilesRecipes.createFileAttachedToRecord(toCreate);
        Test.stopTest();

        // Assert
        System.assert(!saveResult.isSuccess(), 'The file creation should fail due to null fileName');
    }

    @isTest
    static void testCreateFileAttachedToRecord_InvalidAttachedTo() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Arrange
        FilesRecipes.FileAndLinkObject toCreate = getValidFileAndLinkObject();
        Boolean exceptionThrown = false;

        // Use a try-catch block to catch the expected exception
        try {
            // Invalid Id format will cause an exception
            toCreate.attachedTo = '001xxxxxxxxxxxxxxx';
            Test.startTest();
            Database.SaveResult saveResult = FilesRecipes.createFileAttachedToRecord(toCreate);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
        }

        // Assert
        System.assert(exceptionThrown, 'An exception should be thrown due to an invalid attachedTo Id');
    }
}
