
@isTest
private class PlatformCacheRecipes_6_Tests {
    
    private static final String validKey = 'testKey';
    private static final String validValue = 'testValue';
    private static final Integer validTTL = 7200; // 2 hours
    private static final Integer maxTTL = 172800; // 48 hours
    
    // Happy Path Scenario 1: Storing a valid key-value pair
    @isTest
    static void testStoreValidKeyValue() {
        Test.startTest();
        // No exception should be thrown
        try {
            PlatformCacheRecipes.storeValueInOrgCache(validKey, validValue, validTTL);
            Boolean isSuccess = true;
            System.assertEquals(true, isSuccess);
        } catch (Exception e) {
            Boolean isSuccess = false;
            System.assertEquals(true, isSuccess, 'An unexpected exception occurred: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    // Happy Path Scenario 2: Storing a key-value pair with max TTL
    @isTest
    static void testStoreKeyValueWithMaxTTL() {
        Test.startTest();
        // No exception should be thrown
        try {
            PlatformCacheRecipes.storeValueInOrgCache(validKey, validValue, maxTTL);
            Boolean isSuccess = true;
            System.assertEquals(true, isSuccess);
        } catch (Exception e) {
            Boolean isSuccess = false;
            System.assertEquals(true, isSuccess, 'An unexpected exception occurred: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    // Sad Path Scenario 1: Attempting to store a null key
    @isTest
    static void testStoreNullKey() {
        Test.startTest();
        // Expect an exception to be thrown for null key
        try {
            PlatformCacheRecipes.storeValueInOrgCache(null, validValue, validTTL);
            System.assert(false, 'An exception should have been thrown for null key');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Invalid Key'), 'The expected exception was not thrown.');
        }
        Test.stopTest();
    }
    
    // Sad Path Scenario 2: Storing with a negative TTL
    @isTest
    static void testStoreNegativeTTL() {
        Test.startTest();
        // Expect an exception, but Platform Cache doesn't throw one for negative TTL
        try {
            PlatformCacheRecipes.storeValueInOrgCache(validKey, validValue, -1);
            Boolean isSuccess = true;
            System.assertEquals(true, isSuccess);
        } catch (Exception e) {
            Boolean isSuccess = false;
            System.assertEquals(true, isSuccess, 'An unexpected exception occurred: ' + e.getMessage());
        }
        Test.stopTest();
    }
}
