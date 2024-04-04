
@isTest
public class EncryptionRecipes_12_Tests {
    // Since there is no need for DML in this test, there's no need to disable triggers
    // as it's not affecting any Salesforce object directly.
    
    // Test data setup is not needed for this unit test, as the method does not depend on Salesforce data.
    
    @isTest
    static void testGenerateHMACSHA512RecipeWithValidData() {
        // Prepare test data
        Blob dataToHmac = Blob.valueOf('Test data for HMAC');

        // Execute the method
        Test.startTest();
        Blob hmacResult = EncryptionRecipes.generateHMACSHA512Recipe(dataToHmac);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, hmacResult, 'The HMAC should not be null.');
        System.assertEquals(88, EncodingUtil.base64Encode(hmacResult).length(), 'The length of the base64 encoded HMAC should be 88.');
    }

    @isTest
    static void testGenerateHMACSHA512RecipeWithNullData() {
        // No need to prepare test data since we are testing the null scenario

        Exception actualException;

        // Execute
        Test.startTest();
        try {
            Blob hmacResult = EncryptionRecipes.generateHMACSHA512Recipe(null);
        } catch (Exception e) {
            actualException = e;
        }
        Test.stopTest();

        // Verify that an exception was thrown
        System.assertNotEquals(null, actualException, 'An exception should be thrown when trying to generate HMAC with null data.');
    }
}
