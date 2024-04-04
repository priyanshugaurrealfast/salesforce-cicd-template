
@isTest
private class CanTheUser_7_Tests {
    @testSetup
    static void setupTestData(){
        // Create test data for Account since CanTheUser will be checking against the Account SObject
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    @isTest
    static void testCanReadWithReadAccess(){
        // Test for happy path where the user has read access to the Account object
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Test.startTest();
        Boolean canRead = CanTheUser.read(new Account());
        Test.stopTest();
        
        // Assert user has read permissions
        System.assertEquals(true, canRead, 'The user should have read access to Account.');
    }
    
    @isTest
    static void testCanReadWithNullObject() {
        // Test for exceptional scenario where null is passed instead of a valid sObject
        // Since passing null directly causes ambiguity, explicitly cast null to Account
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Boolean canRead;
        Boolean exceptionThrown = false;
        
        try {
            Test.startTest();
            canRead = CanTheUser.read((SObject)null);
            Test.stopTest();
        } catch (System.NullPointerException e) {
            exceptionThrown = true;
        }
        
        // Assert that a NullPointerException is thrown
        System.assertEquals(true, exceptionThrown, 'A NullPointerException should be thrown when trying to read a null object.');
    }
}
