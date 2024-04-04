
@isTest
private class CollectionUtils_3_Tests {

    @testSetup
    static void setup() {
        // Prepare test data - Create Accounts and Contacts
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'TestAccount' + i));
        }
        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        for(Account acc : testAccounts) {
            testContacts.add(new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id));
            // Adding more than one contact per account to test collection in map
            testContacts.add(new Contact(FirstName = 'Test2', LastName = 'Contact2', AccountId = acc.Id));
        }
        insert testContacts;
    }

    @isTest
    static void testWithValidData() {
        // Disable Account trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        // Retrieve test data
        List<Contact> contacts = [SELECT AccountId, firstName, lastName FROM Contact];
        // Call the target method
        Map<Id, List<SObject>> result = CollectionUtils.mapFromCollectionWithCollectionValues('AccountId', contacts);
        Test.stopTest();

        // Assertions
        System.assertEquals(5, result.size(), 'Should have 5 entries in the map, one per account.');
        for(List<SObject> contactList: result.values()) {
            System.assertEquals(2, contactList.size(), 'Each entry should have a list of 2 contacts.');
        }
    }

    @isTest
    static void testWithEmptyList() {
        // Disable Account trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        // Pass an empty list
        Map<Id, List<SObject>> result = CollectionUtils.mapFromCollectionWithCollectionValues('AccountId', new List<Contact>());
        Test.stopTest();

        // Assertions
        System.assertEquals(true, result.isEmpty(), 'The result should be an empty map.');
    }

    @isTest
    static void testWithInvalidKey() {
        // Disable Account trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Exception caughtException = null;

        Test.startTest();
        // Retrieve test data
        List<Contact> contacts = [SELECT AccountId, firstName, lastName FROM Contact];
        try {
            // Call the target method with an invalid field name
            Map<Id, List<SObject>> result = CollectionUtils.mapFromCollectionWithCollectionValues('InvalidField', contacts);
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown due to an invalid key.');
    }

    @isTest
    static void testWithMixedValueKeys() {
        // Disable Account trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        // Retrieve test data and manipulate to create nulls
        List<Contact> contacts = [SELECT AccountId, firstName, lastName FROM Contact LIMIT 2];
        contacts.add(new Contact(FirstName = 'TestNull', LastName = 'ContactNull'));
        // Call the target method
        Map<Id, List<SObject>> result = CollectionUtils.mapFromCollectionWithCollectionValues('AccountId', contacts);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(0, result.size(), 'Should have entries in the map.');
        System.assertNotEquals(null, result.get(null), 'Map should contain null key for contacts with null AccountId.');
        
        // Since we have 3 contacts and 1 with null AccountId, we expect 3 entries
        System.assertEquals(3, result.size(), 'Should have 3 entries including nulls.');
        for (Id accountId : result.keySet()) {
            if (accountId != null) {
                System.assertEquals(2, result.get(accountId).size(), 'Each entry should have a list of contacts.');
            } else {
                System.assertEquals(1, result.get(accountId).size(), 'Null key entry should have a list with a single contact.');
            }
        }
    }
}
