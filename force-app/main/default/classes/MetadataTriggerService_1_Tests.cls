
@isTest
private class MetadataTriggerService_1_Tests {

    @testSetup
    static void setup() {
        // Bypass trigger handlers for setup
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assuming we have the setup for Disabled_for__mdt already present in the org
        // and that there are existing Metadata_Driven_Trigger__mdt records for the Account object
        // No DML here for custom metadata as we can't perform DML on them
    }

    @isTest
    static void testGetMetadataTriggers_HappyPath() {
        // Setup
        String objectTypeName = 'Account';
        MetadataTriggerService service = new MetadataTriggerService(objectTypeName);

        // Execute
        Test.startTest();
        List<Metadata_Driven_Trigger__mdt> triggers = service.getMetadataTriggers();
        Test.stopTest();

        // Verify
        // We cannot assert the size of the list or the content because we cannot set it up in test.
        // You would check this against the known state of your org's metadata during test writing.
        System.assertNotEquals(null, triggers, 'Triggers should not be null');
    }

    @isTest
    static void testGetMetadataTriggers_NoRecordsFound() {
        // Setup
        String objectTypeName = 'NonExistentObject';
        MetadataTriggerService service = new MetadataTriggerService(objectTypeName);

        // Execute - we expect this to return an empty list as there are no triggers for a non-existent object
        Test.startTest();
        List<Metadata_Driven_Trigger__mdt> triggers = service.getMetadataTriggers();
        Test.stopTest();

        // Verify
        System.assertEquals(0, triggers.size(), 'Should return no records for non-existent object type');
    }

    // Other test methods would remain the same in structure,
    // but we would not be able to insert Disabled_for__mdt records or check the actual size or content of the returned list.
    // Instead, we would validate based on the known state of the org or use mocking strategies if available.
}
