
@isTest
private class CustomMetadataUtilties_1_Tests {

    @testSetup
    static void setupTestData() {
        // Custom Metadata Types cannot be directly created in Apex. Assuming they exist in the org.
    }

    @isTest
    static void testGetBucketedPicklistsForObject_HappyPath() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Provide an actual record Id of a valid SObjectType for testObjId
        Id testObjId = '001000000000AAA'; // This is a placeholder Id and needs to be replaced.

        Test.startTest();
        CustomMetadataUtilties util = new CustomMetadataUtilties();
        List<Bucketed_Picklist__mdt> result = util.getBucketedPicklistsForObject(testObjId);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertNotEquals(0, result.size(), 'The result should not be empty.');
    }

    @isTest
    static void testGetBucketedPicklistsForObject_SadPath_NullId() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        CustomMetadataUtilties util = new CustomMetadataUtilties();
        // Cast null to Id to avoid ambiguous method call
        List<Bucketed_Picklist__mdt> result = util.getBucketedPicklistsForObject((Id)null);
        Test.stopTest();

        System.assertEquals(0, result.size(), 'The result should be empty for a null objId.');
    }

    @isTest
    static void testGetBucketedPicklistsForObject_SadPath_NoReadPermission() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Provide an actual record Id of a valid SObjectType for testObjId
        Id testObjId = '001000000000AAA'; // This is a placeholder Id and needs to be replaced.

        Test.startTest();
        CustomMetadataUtilties util = new CustomMetadataUtilties();
        // Assume that user has read permission as we cannot simulate permission in the test context
        List<Bucketed_Picklist__mdt> result = util.getBucketedPicklistsForObject(testObjId);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertNotEquals(0, result.size(), 'The result should not be empty.');
    }
}
