
@isTest
private class Safely_10_Tests {

    // Utility method to create test data for Account
    @testSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    // Happy Path: User has delete permission and the operation succeeds
    @isTest
    static void testDoDeleteWithPermission() {
        // Arrange
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Safely safely = new Safely();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act
        List<Database.DeleteResult> deleteResults = safely.doDelete(testAccount);

        // Assert
        System.assertEquals(1, deleteResults.size(), 'Should only have one delete result');
        System.assert(deleteResults[0].isSuccess(), 'The delete operation should be successful');
    }

    // Exception Path: The provided SObject record is null
    // This test method is modified to handle the null record scenario properly
    @isTest
    static void testDoDeleteWithNullRecord() {
        // Arrange
        Safely safely = new Safely();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        Account testAccount = new Account(Name = 'Test Account for Null');
        insert testAccount; // Ensure the record is not null

        // Act
        // Intentionally setting the record to null to simulate the null scenario
        testAccount = null;
        List<Database.DeleteResult> deleteResults;
        Boolean isExceptionThrown = false;
        try {
            deleteResults = safely.doDelete(testAccount);
        } catch (Exception e) {
            isExceptionThrown = true;
        }

        // Assert
        System.assert(isExceptionThrown, 'An exception should have been thrown for a null record');
    }
}
