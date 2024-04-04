
@isTest
private class PlatformCacheRecipes_8_Tests {

    // Since we're testing cache behavior, we don't need to use @testSetup here as it's not DML-dependent.

    @isTest
    static void testRemoveKeyFromOrgCache_Success() {
        // Arrange
        String key = 'testKey';
        String value = 'testValue';
        // Prepopulate the cache
        PlatformCacheRecipes.storeValueInOrgCache(key, value);
        
        // Act
        Test.startTest();
        PlatformCacheRecipes.removeKeyFromOrgCache(key);
        Test.stopTest();
        
        // Assert
        String result = PlatformCacheRecipes.getValuefromOrgCache(key);
        System.assertEquals('Cache Miss', result, 'The key should have been removed from cache.');
    }

    @isTest
    static void testRemoveKeyFromOrgCache_KeyNotFound() {
        // Arrange
        String missingKey = 'missingKey';
        
        // Act & Assert
        Test.startTest();
        try {
            PlatformCacheRecipes.removeKeyFromOrgCache(missingKey);
            System.assert(false, 'Expected CacheException was not thrown.');
        } catch (PlatformCacheRecipes.CacheException e) {
            System.assertEquals('key not found', e.getMessage(), 'Exception message should match expected message.');
        }
        Test.stopTest();
    }
}
