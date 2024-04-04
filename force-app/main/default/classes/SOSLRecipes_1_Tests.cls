
@isTest
private class SOSLRecipes_1_Tests {

    // Use testSetup to create test data
    @testSetup
    static void setupTestData() {
        // Create and insert test data
        // Since we're mocking SOSL results, the specific data is less important.
        Account testAccount = new Account(Name='Kanto');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='Kane', AccountId=testAccount.Id);
        insert testContact;
    }
    
    // Test the happy path where the SOSL search returns expected records
    @isTest
    static void testBasicSOSLSearchHappyPath() {
        // Mock SOSL results
        Id accId = [SELECT Id FROM Account WHERE Name='Kanto' LIMIT 1].Id;
        Id contactId = [SELECT Id FROM Contact WHERE LastName='Kane' LIMIT 1].Id;
        List<List<SObject>> expectedResults = new List<List<SObject>>{
            new List<SObject>{new Account(Id = accId, Name = 'Kanto')},
            new List<SObject>{new Contact(Id = contactId, LastName = 'Kane')}
        };

        Test.setFixedSearchResults(new List<Id>{accId, contactId});
        
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Test.startTest();
        List<List<SObject>> actualResults = SOSLRecipes.basicSOSLSearch();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(expectedResults.size(), actualResults.size(), 'Should return correct number of record lists.');
        System.assertEquals(expectedResults[0].size(), actualResults[0].size(), 'Should return the correct number of accounts.');
    }
    
    // Test the sad path where the SOSL search returns no records
    @isTest
    static void testBasicSOSLSearchSadPath() {
        // Mock empty SOSL results
        Test.setFixedSearchResults(new List<Id>{});
        
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Test.startTest();
        List<List<SObject>> actualResults = SOSLRecipes.basicSOSLSearch();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, actualResults.size(), 'Should return empty lists for both Account and Contact.');
        System.assertEquals(0, actualResults[0].size(), 'Should return an empty list for Account.');
        System.assertEquals(0, actualResults[1].size(), 'Should return an empty list for Contact.');
    }
}
