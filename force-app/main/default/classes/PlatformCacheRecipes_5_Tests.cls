
@isTest
private class PlatformCacheRecipes_5_Tests {
    
    @isTest
    static void testStoreValueInOrgCacheWithDefaultTimeout() {
        String key = 'testKey';
        String value = 'testValue';

        Test.startTest();
        PlatformCacheRecipes.storeValueInOrgCache(key, value);
        Test.stopTest();

        String cachedValue = PlatformCacheRecipes.getValuefromOrgCache(key);
        System.assertEquals(value, cachedValue, 'The value should be stored in the cache.');
    }

    @isTest
    static void testStoreNullKeyInOrgCache() {
        String key = null;
        String value = 'testValue';

        Boolean isExceptionThrown = false;
        Test.startTest();
        try {
            PlatformCacheRecipes.storeValueInOrgCache(key, value);
        } catch (cache.InvalidParamException e) {
            isExceptionThrown = true;
        }
        Test.stopTest();

        System.assert(isExceptionThrown, 'An InvalidParamException should be thrown when the key is null.');
    }

    @isTest
    static void testStoreNullValueInOrgCache() {
        String key = 'testKey';
        String value = null;

        Boolean isExceptionThrown = false;
        Test.startTest();
        try {
            PlatformCacheRecipes.storeValueInOrgCache(key, value);
        } catch (cache.InvalidParamException e) {
            isExceptionThrown = true;
        }
        Test.stopTest();

        System.assert(isExceptionThrown, 'An InvalidParamException should be thrown when the value is null.');
    }
}
