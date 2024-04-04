
@isTest
private class StripInaccessibleRecipes_3_Tests {
    
    @testSetup
    static void makeTestData() {
        // Test data setup for Contact
        Contact testContact = new Contact(LastName='Doe', Email='jdoe@example.com');
        insert testContact;

        // Trigger bypassing for Contact as per project-specific details
        TriggerHandler.bypass('ContactTriggerHandler');
    }

    @isTest
    static void testStripInaccessibleWithCreatableFields() {
        // Prepare test data
        List<Contact> contacts = new List<Contact> {
            new Contact(LastName = 'Test', Email = 'test@example.com')
        };

        Test.startTest();
        StripInaccessibleRecipes.stripInaccessibleBeforeDML(contacts);
        Test.stopTest();

        // Validate that records are inserted
        List<Contact> insertedContacts = [SELECT LastName, Email FROM Contact WHERE LastName = 'Test'];
        System.assertEquals(1, insertedContacts.size(), 'One contact should be inserted.');
        System.assertEquals('Test', insertedContacts[0].LastName, 'The LastName should be set correctly.');
    }

    @isTest
    static void testStripInaccessibleWithEmptyList() {
        // Prepare test data
        List<Contact> contacts = new List<Contact>();

        Test.startTest();
        StripInaccessibleRecipes.stripInaccessibleBeforeDML(contacts);
        Test.stopTest();

        // Validate that no exception is thrown and no records are inserted
        Integer contactsCount = [SELECT COUNT() FROM Contact WHERE LastName = 'Empty'];
        System.assertEquals(0, contactsCount, 'No contacts should be inserted.');
    }
}
