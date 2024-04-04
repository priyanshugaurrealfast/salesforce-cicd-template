
@isTest
private class FilesRecipes_4_Tests {

    @testSetup
    static void setup() {
        // Create test data for Accounts; linked to the files we will create
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }
    
    @isTest
    static void shouldSuccessfullyCreateAndLinkFiles() {
        // Disable Account triggers before performing DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Prepare test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Blob fileContent = Blob.valueOf('Test Content');
        FilesRecipes.FileAndLinkObject fileLinkObj = new FilesRecipes.FileAndLinkObject();
        fileLinkObj.fileContents = fileContent;
        fileLinkObj.attachedTo = testAccount.Id;
        fileLinkObj.fileName = 'TestFile.txt';

        // Call the method under test
        Test.startTest();
        List<Database.SaveResult> results = FilesRecipes.createFilesAttachedToRecords(new List<FilesRecipes.FileAndLinkObject>{fileLinkObj});
        Test.stopTest();

        // Assert that the file was created successfully
        System.assertEquals(1, results.size(), 'One file should have been created.');
        System.assert(results[0].isSuccess(), 'The file creation should have been successful.');
    }

    @isTest
    static void shouldHandleNullFileContents() {
        // Disable Account triggers before performing DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Prepare test data with null fileContents
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        FilesRecipes.FileAndLinkObject fileLinkObj = new FilesRecipes.FileAndLinkObject();
        fileLinkObj.fileContents = null;
        fileLinkObj.attachedTo = testAccount.Id;
        fileLinkObj.fileName = 'TestFile.txt';

        // Call the method under test
        List<Database.SaveResult> results;
        Test.startTest();
        results = FilesRecipes.createFilesAttachedToRecords(new List<FilesRecipes.FileAndLinkObject>{fileLinkObj});
        Test.stopTest();

        // Assert that a failure SaveResult was returned
        System.assertEquals(1, results.size(), 'There should be one result for the attempted file creation.');
        System.assert(!results[0].isSuccess(), 'The file creation should not have been successful due to null contents.');
    }

    @isTest
    static void shouldHandleDmlException() {
        // Disable Account triggers before performing DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Prepare test data with a valid format but non-existent Id
        Blob fileContent = Blob.valueOf('Test Content');
        FilesRecipes.FileAndLinkObject fileLinkObj = new FilesRecipes.FileAndLinkObject();
        fileLinkObj.fileContents = fileContent;
        fileLinkObj.attachedTo = '001000000000XYZ'; // Valid format, non-existent Id
        fileLinkObj.fileName = 'TestFile.txt';

        // Call the method under test
        List<Database.SaveResult> results;
        Test.startTest();
        results = FilesRecipes.createFilesAttachedToRecords(new List<FilesRecipes.FileAndLinkObject>{fileLinkObj});
        Test.stopTest();

        // Assert that no SaveResult was returned due to DML exception
        System.assertEquals(0, results.size(), 'No results should be returned due to DML exception.');
    }
}
