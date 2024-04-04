
@isTest
private class SOSLRecipes_2_Tests {

    @testSetup
    static void setupTestData() {
        // Bypass triggers before creating test data
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create Account and Contact test data
        Account testAccount = new Account(Name='Alaska Systems');
        insert testAccount;

        Contact testContact = new Contact(LastName='Alaska', AccountId=testAccount.Id);
        insert testContact;
    }

    @isTest
    static void testHappyPath() {
        // Set fixed search results for SOSL
        List<Id> fixedSearchResults = new List<Id>{[SELECT Id FROM Account WHERE Name = 'Alaska Systems'].Id};
        Test.setFixedSearchResults(fixedSearchResults);
        
        // Call method under test
        Test.startTest();
        List<List<SObject>> searchResults = SOSLRecipes.nameFieldSearch();
        Test.stopTest();
        
        // Assert results are correct
        System.assertNotEquals(null, searchResults, 'Search results should not be null');
        System.assertEquals(2, searchResults.size(), 'Expected two lists for account and contact');
        System.assertEquals(1, searchResults[0].size(), 'Expected one account to be found');
        System.assertEquals(0, searchResults[1].size(), 'Expected no contacts to be found with the keyword.');
    }

    @isTest
    static void testSadPath() {
        // Set empty fixed search results for SOSL
        Test.setFixedSearchResults(new List<Id>());
        
        // Call method under test
        Test.startTest();
        List<List<SObject>> searchResults = SOSLRecipes.nameFieldSearch();
        Test.stopTest();
        
        // Assert results indicate no records found
        System.assertNotEquals(null, searchResults, 'Search results should not be null');
        System.assertEquals(2, searchResults.size(), 'Expected two lists for account and contact');
        System.assertEquals(0, searchResults[0].size(), 'Expected no accounts to be found');
        System.assertEquals(0, searchResults[1].size(), 'Expected no contacts to be found');
    }

    @isTest
    static void testExceptionalScenario() {
        // Assume that search results are not correctly set up and test the outcome
        Test.startTest();
        List<List<SObject>> searchResults = SOSLRecipes.nameFieldSearch();
        Test.stopTest();
        
        // Assert that without setting up fixed search results, SOSL returns no records
        System.assertNotEquals(null, searchResults, 'Search results should not be null');
        System.assertEquals(2, searchResults.size(), 'Expected two lists for account and contact');
        System.assertEquals(0, searchResults[0].size(), 'Expected no accounts without fixed search results');
        System.assertEquals(0, searchResults[1].size(), 'Expected no contacts without fixed search results');
    }
}
