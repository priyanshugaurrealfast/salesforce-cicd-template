
@isTest
public class FilesRecipes_1_Tests {

    @testSetup
    static void setup() {
        // Create an Account for testing
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testCreateFileFromString_HappyPath() {
        // Retrieve test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        String content = 'Test File Content';

        // Perform test
        Test.startTest();
        FilesRecipes.createFileFromStringAttachedToRecord(content, testAccount.Id);
        Test.stopTest();

        // Verify that a ContentDocumentLink was created and linked to the test Account
        List<ContentDocumentLink> cdls = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :testAccount.Id];
        System.assertEquals(1, cdls.size(), 'One file should be linked to the account.');

        // Verify the ContentVersion record details
        ContentVersion cv = [SELECT Title, VersionData FROM ContentVersion WHERE ContentDocumentId = :cdls[0].ContentDocumentId ORDER BY CreatedDate DESC LIMIT 1];
        System.assertEquals('AwesomeFile1', cv.Title, 'File title should match expected value.');
        
        // Corrected assertion to compare the string representation of the Blob data
        System.assertEquals(content, cv.VersionData.toString(), 'File content should match the provided string.');
    }

    @isTest
    static void testCreateFileFromString_NullLocation() {
        // Prepare a null Id for the firstLocation parameter
        Id nullId = null;
        String content = 'Test File Content';

        // Perform test with an expected exception
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            FilesRecipes.createFileFromStringAttachedToRecord(content, nullId);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        // Verify that an exception was thrown due to the null Id
        System.assert(exceptionThrown, 'An exception should have been thrown due to a null firstLocation Id.');
    }
}
