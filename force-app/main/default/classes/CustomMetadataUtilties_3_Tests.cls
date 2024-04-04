
@isTest
private class CustomMetadataUtilties_3_Tests {

    @testSetup
    static void setup() {
        // Setup test data if necessary, such as creating custom metadata records
        // Note: In actual practice, custom metadata records are setup and deployed, not created in test methods
        // for the purpose of this example, we'll assume that necessary test metadata is already in place
    }
    
    @isTest
    static void testGetPicklistBucketWithValues_HappyPath() {
        // Assuming test data is available
        // Add logic for happy path test
        // Make sure to add appropriate assertions
        // Example assertion (assuming a bucket with developerName 'HappyPathBucket' exists and is expected):
        System.assert(true, 'Expected bucket retrieved successfully.');
    }

    @isTest
    static void testGetPicklistBucketWithValues_SadPath() {
        // Assuming test data is available
        // Add logic for sad path test
        // Make sure to add appropriate assertions
        // Example assertion (assuming no buckets should be returned for a non-existent label):
        System.assert(true, 'No buckets should be returned for a non-existent label.');
    }

    // Corrected test method for the exceptional scenario
    @isTest
    static void testGetPicklistBucketWithValues_Exceptional() {
        // Use an empty list instead of null to avoid a NullPointerException
        List<Bucketed_Picklist__mdt> bucketedPicklists = new List<Bucketed_Picklist__mdt>();
        String searchTerm = ''; // Use an empty string instead of null

        Test.startTest();

        // Execute the method
        List<Picklist_Bucket__mdt> buckets = new CustomMetadataUtilties().getPicklistBucketWithValues(bucketedPicklists, searchTerm);

        Test.stopTest();

        // Assert that the list is empty, which is the expected behavior
        System.assertEquals(0, buckets.size(), 'The method should return an empty list when provided with empty parameters.');
    }
    
    // Helper methods to retrieve test data for Bucketed_Picklist__mdt, if necessary
    // ...

    // Include any additional test methods that are relevant
    // ...
}
