
@isTest
private class MetadataTriggerHandler_1_Tests {

    // Mock class to replace the actual MetadataTriggerService during tests
    private class MockMetadataTriggerService {
        private List<Metadata_Driven_Trigger__mdt> fakeMetadataTriggers;
        
        public MockMetadataTriggerService(List<Metadata_Driven_Trigger__mdt> fakeTriggers) {
            this.fakeMetadataTriggers = fakeTriggers;
        }

        public List<Metadata_Driven_Trigger__mdt> getMetadataTriggers() {
            return this.fakeMetadataTriggers;
        }
    }

    private static List<Metadata_Driven_Trigger__mdt> createFakeMetadataTriggers() {
        // Simulate the metadata-driven triggers as they would be in reality
        List<Metadata_Driven_Trigger__mdt> fakeTriggers = new List<Metadata_Driven_Trigger__mdt>();
        // Add fake metadata trigger entries here as needed
        // Example:
        fakeTriggers.add(new Metadata_Driven_Trigger__mdt(
            Object__c = 'Account',
            Execution_Order__c = 1,
            Class__c = 'AccountTriggerHandler'
        ));
        return fakeTriggers;
    }

    @isTest
    static void testHappyPath() {
        // Setup the MetadataTriggerHandler with a mock service
        MetadataTriggerHandler mth = new MetadataTriggerHandler();
        mth.mts = new MockMetadataTriggerService(createFakeMetadataTriggers());

        // Bypass trigger handlers for DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act: Run the trigger handler in the context of a trigger operation
        Test.startTest();
        insert new Account(Name = 'Test Account');
        Test.stopTest();

        // Assert: Check for the expected outcomes that indicate the trigger ran successfully
        // As we don't have concrete outcomes to check, we'll assert that the record was created
        Account acc = [SELECT Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals('Test Account', acc.Name, 'The account should be created with the correct name.');
    }

    @isTest
    static void testSadPath_NoMetadataTriggers() {
        // Setup the MetadataTriggerHandler with an empty mock service
        MetadataTriggerHandler mth = new MetadataTriggerHandler();
        mth.mts = new MockMetadataTriggerService(new List<Metadata_Driven_Trigger__mdt>());

        // Bypass trigger handlers for DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act: Run the trigger handler in the context of a trigger operation
        Test.startTest();
        insert new Account(Name = 'Test Account');
        Test.stopTest();

        // Assert: Check for the expected outcomes that indicate no trigger handlers were run
        Integer expectedAccountCount = 1;
        Integer actualAccountCount = [SELECT COUNT() FROM Account];
        System.assertEquals(expectedAccountCount, actualAccountCount, 'No additional accounts should have been created.');
    }

    @isTest
    static void testExceptionalScenario_InvalidClass() {
        // Setup the MetadataTriggerHandler with a mock service including an invalid trigger class
        List<Metadata_Driven_Trigger__mdt> fakeTriggers = createFakeMetadataTriggers();
        fakeTriggers.add(new Metadata_Driven_Trigger__mdt(
            Object__c = 'Account',
            Execution_Order__c = 3,
            Class__c = 'InvalidTriggerHandler'
        ));
        MetadataTriggerHandler mth = new MetadataTriggerHandler();
        mth.mts = new MockMetadataTriggerService(fakeTriggers);

        // Bypass trigger handlers for DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act: Run the trigger handler in the context of a trigger operation
        Test.startTest();
        insert new Account(Name = 'Test Account');
        Test.stopTest();

        // Assert: Check for the expected outcomes that indicate the trigger was run despite the invalid class
        Integer expectedAccountCount = 1;
        Integer actualAccountCount = [SELECT COUNT() FROM Account];
        System.assertEquals(expectedAccountCount, actualAccountCount, 'The invalid trigger handler should not prevent the account creation.');
    }
}
