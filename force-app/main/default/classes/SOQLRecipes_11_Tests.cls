
@isTest
private class SOQLRecipes_11_Tests {

    @testSetup
    static void setup() {
        // Disabling the triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create test data
        Account testAccountKS = new Account(Name = 'Test Account KS', ShippingState = 'KS');
        insert testAccountKS;
        
        Account testAccountNY = new Account(Name = 'Test Account NY', ShippingState = 'NY');
        insert testAccountNY;

        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'Test', LastName = 'Contact 1', Email = 'test1@test.com', AccountId = testAccountKS.Id),
            new Contact(FirstName = 'Test', LastName = 'Contact 2', Email = 'test2@test.com', AccountId = testAccountKS.Id),
            new Contact(FirstName = 'Test', LastName = 'Contact NY', Email = 'testny@test.com', AccountId = testAccountNY.Id) // This should not be returned by the query
        };
        insert contacts;
    }

    @isTest
    static void testGetParentRecordDetailsFromChildRecord_HappyPath() {
        Test.startTest();
        List<Contact> results = SOQLRecipes.getParentRecordDetailsFromChildRecord();
        Test.stopTest();

        // Assertions
        System.assertEquals(2, results.size(), 'There should be two contacts with Account ShippingState as KS');
        for (Contact c : results) {
            System.assertEquals('KS', c.Account.ShippingState, 'Parent account ShippingState should be KS');
        }
    }

    @isTest
    static void testGetParentRecordDetailsFromChildRecord_SadPath() {
        // Update the Account ShippingState so that there are no matches
        List<Account> accountsToUpdate = [SELECT Id FROM Account WHERE ShippingState = 'KS'];
        for (Account a : accountsToUpdate) {
            a.ShippingState = 'CA';
        }
        update accountsToUpdate;

        Test.startTest();
        List<Contact> results = SOQLRecipes.getParentRecordDetailsFromChildRecord();
        Test.stopTest();

        // Assertions
        System.assertEquals(0, results.size(), 'There should be no contacts with Account ShippingState as KS');
    }
}
