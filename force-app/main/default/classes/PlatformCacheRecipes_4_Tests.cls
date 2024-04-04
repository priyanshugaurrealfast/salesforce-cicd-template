
@isTest
private class PlatformCacheRecipes_4_Tests {

    // Test setup to create initial cache data
    @testSetup
    private static void setup() {
        // Store a value in session cache to use it in the tests
        String testKey = 'testKey';
        String testValue = 'testValue';
        PlatformCacheRecipes.storeValueInSessionCache(testKey, testValue);
    }

    @isTest
    private static void testRemoveKeyFromSessionCacheHappyPath() {
        // Retrieving the test key initially to ensure it's there
        String testKey = 'testKey';
        String valueBeforeRemoval = PlatformCacheRecipes.getValueFromSessionCache(testKey);
        Test.startTest();
        // Removing the key from session cache
        PlatformCacheRecipes.removeKeyFromSessionCache(testKey);
        Test.stopTest();

        // Retrieving the value after removal to ensure it's not there
        String valueAfterRemoval = PlatformCacheRecipes.getValueFromSessionCache(testKey);

        // Asserts
        System.assertEquals('testValue', valueBeforeRemoval, 'Cache should contain the test value before removal');
        System.assertEquals('Cache Miss', valueAfterRemoval, 'Cache should miss the test value after removal');
    }

    @isTest
    private static void testRemoveKeyFromSessionCacheSadPath() {
        // Define a key that does not exist in the cache
        String nonExistentKey = 'nonExistentKey';

        // Expect an exception to be thrown
        Boolean isExceptionThrown = false;
        try {
            Test.startTest();
            PlatformCacheRecipes.removeKeyFromSessionCache(nonExistentKey);
            Test.stopTest();
        } catch (PlatformCacheRecipes.CacheException e) {
            isExceptionThrown = true;
            System.assertEquals('key not found', e.getMessage(), 'Exception message should match expected');
        }

        // Assert that an exception was indeed thrown
        System.assert(isExceptionThrown, 'A CacheException should be thrown for a non-existent key');
    }

    @isTest
    private static void testRemoveKeyFromSessionCacheWithNullKey() {
        // Define a null key
        String nullKey = null;

        // Expect an exception to be thrown
        Boolean isExceptionThrown = false;
        try {
            Test.startTest();
            PlatformCacheRecipes.removeKeyFromSessionCache(nullKey);
            Test.stopTest();
        } catch (Exception e) {
            isExceptionThrown = true;
        }

        // Assert that an exception was indeed thrown
        System.assert(isExceptionThrown, 'An exception should be thrown for a null key');
    }
}
