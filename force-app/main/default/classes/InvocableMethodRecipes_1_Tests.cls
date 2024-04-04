
@isTest
private class InvocableMethodRecipes_1_Tests {
    
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;
        
        // Bypass Triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    // Happy path scenario
    @isTest
    static void testContactSearchResultWithValidSObject() {
        Test.startTest();
        // Retrieve the test Contact record
        Contact testContact = [SELECT Id, FirstName, LastName FROM Contact LIMIT 1];
        
        // Initialize ContactSearchResult with a valid SObject
        InvocableMethodRecipes.ContactSearchResult result = new InvocableMethodRecipes.ContactSearchResult(testContact);
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(testContact, result.output, 'The output should be the testContact record.');
        Test.stopTest();
    }
    
    // Edge case scenario: Passing null to the constructor
    @isTest
    static void testContactSearchResultWithNull() {
        Test.startTest();
        // Attempt to initialize ContactSearchResult with null
        InvocableMethodRecipes.ContactSearchResult result = new InvocableMethodRecipes.ContactSearchResult(null);
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(null, result.output, 'The output should be null.');
        Test.stopTest();
    }
}
