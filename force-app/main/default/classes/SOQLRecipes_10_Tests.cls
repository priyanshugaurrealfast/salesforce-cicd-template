
@isTest
private class SOQLRecipes_10_Tests {

    @testSetup
    static void setupTestData() {
        // Prepare some test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'TestAccount' + i));
        }
        insert testAccounts;

        // Prepare some test contacts related to the test accounts
        List<Contact> testContacts = new List<Contact>();
        for (Account acct : testAccounts) {
            testContacts.add(new Contact(LastName = 'TestContact', AccountId = acct.Id));
        }
        insert testContacts;
    }

    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testGetRecordsWithRelatedRecords() {
        disableTriggers();

        Test.startTest();
        List<Account> accountsWithContacts = SOQLRecipes.getRecordsWithRelatedRecords();
        Test.stopTest();

        System.assertEquals(5, accountsWithContacts.size(), 'Should retrieve 5 accounts');
        System.assertNotEquals(null, accountsWithContacts[0].Contacts, 'First account should have related contacts');
    }

    @isTest
    static void testGetRecordsWithRelatedRecords_NoContacts() {
        disableTriggers();
        
        // Remove all contacts to simulate accounts with no related contacts
        delete [SELECT Id FROM Contact];

        Test.startTest();
        List<Account> accountsWithContacts = SOQLRecipes.getRecordsWithRelatedRecords();
        Test.stopTest();

        System.assertEquals(5, accountsWithContacts.size(), 'Should retrieve 5 accounts');
        System.assertEquals(0, accountsWithContacts[0].Contacts.size(), 'First account should have no related contacts');
    }

    @isTest
    static void testGetRecordsWithRelatedRecords_NoAccounts() {
        disableTriggers();
        
        // Remove all accounts to simulate no available accounts
        delete [SELECT Id FROM Account];

        Test.startTest();
        List<Account> accountsWithContacts = SOQLRecipes.getRecordsWithRelatedRecords();
        Test.stopTest();

        System.assertEquals(0, accountsWithContacts.size(), 'Should retrieve 0 accounts');
    }
}
