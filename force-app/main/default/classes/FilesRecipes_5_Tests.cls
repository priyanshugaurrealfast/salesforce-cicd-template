
@isTest
private class FilesRecipes_5_Tests {

    // Creates test data for the unit tests
    @testSetup
    static void setup() {
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create test files to be attached to the account
        ContentVersion testImage = createTestContentVersion('Test Image', 'image.jpg', testAccount.Id);
        ContentVersion testAudio = createTestContentVersion('Test Audio', 'audio.mp3', testAccount.Id);
        ContentVersion testDocument = createTestContentVersion('Test Document', 'document.pdf', testAccount.Id);

        insert new List<ContentVersion>{ testImage, testAudio, testDocument };
    }

    // Helper method to create a ContentVersion record.
    private static ContentVersion createTestContentVersion(String title, String pathOnClient, Id attachedTo) {
        return new ContentVersion(
            Title = title,
            PathOnClient = pathOnClient,
            VersionData = Blob.valueOf('Test Data'),
            FirstPublishLocationId = attachedTo
        );
    }

    // Tests retrieving filtered attachments for IMAGE file type
    @isTest
    static void shouldReturnImageAttachments() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        List<ContentVersion> result = FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.IMAGE, testAccount.Id);
        System.assertEquals(1, result.size(), 'Expected to find one image attachment');
        System.assertEquals('image.jpg', result[0].PathOnClient.substringAfterLast('.'), 'Expected to find an image file extension');
    }

    // Tests retrieving filtered attachments for AUDIO file type
    @isTest
    static void shouldReturnAudioAttachments() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        List<ContentVersion> result = FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.AUDIO, testAccount.Id);
        System.assertEquals(1, result.size(), 'Expected to find one audio attachment');
        System.assertEquals('mp3', result[0].PathOnClient.substringAfterLast('.'), 'Expected to find an audio file extension');
    }

    // Tests retrieving filtered attachments for DOCUMENT file type
    @isTest
    static void shouldReturnDocumentAttachments() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        List<ContentVersion> result = FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.DOCUMENT, testAccount.Id);
        System.assertEquals(1, result.size(), 'Expected to find one document attachment');
        System.assertEquals('pdf', result[0].PathOnClient.substringAfterLast('.'), 'Expected to find a document file extension');
    }

    // Tests retrieving all types of attachments
    @isTest
    static void shouldReturnAllAttachments() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        List<ContentVersion> result = FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.ALL, testAccount.Id);
        System.assertEquals(3, result.size(), 'Expected to find all attachments');
    }

    // Tests the behavior when there are no attachments of the specified type
    @isTest
    static void shouldReturnEmptyListWhenNoAttachmentsFound() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        List<ContentVersion> result = FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.AUDIO, '001000000000000AAA'); // Dummy ID
        System.assertEquals(0, result.size(), 'Expected to find no attachments');
    }

    // Tests the behavior when the user has no read access to ContentVersion
    @isTest
    static void shouldThrowExceptionWhenNoReadAccess() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        System.runAs(new User(Id = UserInfo.getUserId())) { // Running as the current user for now
            Boolean exceptionThrown = false;
            try {
                FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.IMAGE, testAccount.Id);
            } catch (FilesRecipes.FilesRecipesException e) {
                exceptionThrown = true;
                System.assertEquals('User has no Access to ContentVersion', e.getMessage(), 'Expected specific exception message');
            }
            System.assert(exceptionThrown, 'Expected FilesRecipesException to be thrown');
        }
    }
}
