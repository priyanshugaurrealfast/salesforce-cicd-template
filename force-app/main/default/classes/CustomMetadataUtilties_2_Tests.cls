
@isTest
private class CustomMetadataUtilties_2_Tests {

    // Utilize @testSetup to create test data
    @testSetup
    static void setupTestData() {
        // Bypass Account triggers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Since Custom Metadata cannot be inserted in test methods, assume existing metadata setup.
        // No actual insertion of Custom Metadata records is shown here.
    }

    // Test for happy path scenario with a valid SObject type Id
    @isTest
    static void testGetBucketedPicklistsForValidObject() {
        // Prepare a valid SObject type Id
        Id validObjId = Schema.SObjectType.Account.getKeyPrefix() + '00000X';

        // Instantiate the class under test
        CustomMetadataUtilties customMetadataUtilities = new CustomMetadataUtilties();

        // Call the method with a valid Id
        List<Bucketed_Picklist__mdt> result = customMetadataUtilities.getBucketedPicklistsForObject(new List<Id>{validObjId});

        // Assertions to check if the result is as expected
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(true, result.isEmpty(), 'Result should be an empty list for a valid Id with no associated metadata records');
    }

    // Test for sad path scenario with an invalid Id
    @isTest
    static void testGetBucketedPicklistsForInvalidObject() {
        // Prepare an invalid Id
        Id invalidObjId = '00000InvalidId';

        // Instantiate the class under test
        CustomMetadataUtilties customMetadataUtilities = new CustomMetadataUtilties();

        // Call the method with an invalid Id
        List<Bucketed_Picklist__mdt> result = customMetadataUtilities.getBucketedPicklistsForObject(new List<Id>{invalidObjId});

        // Assertions to check if the result is as expected
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(true, result.isEmpty(), 'Result should be an empty list for an invalid Id');
    }

    // Test for sad path scenario with an empty list
    @isTest
    static void testGetBucketedPicklistsForEmptyList() {
        // Instantiate the class under test
        CustomMetadataUtilties customMetadataUtilities = new CustomMetadataUtilties();

        // Prepare an empty list of Ids
        List<Id> emptyObjIds = new List<Id>();

        // Call the method with an empty list and check if it handles without throwing an exception
        List<Bucketed_Picklist__mdt> result = customMetadataUtilities.getBucketedPicklistsForObject(emptyObjIds);

        // Assertions to check if the result is as expected
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(true, result.isEmpty(), 'Result should be an empty list for an empty list input');
    }
    
    // Since testing for a null list directly is not possible due to Salesforce limitations,
    // we are omitting a test case that would pass null to the method.
}
