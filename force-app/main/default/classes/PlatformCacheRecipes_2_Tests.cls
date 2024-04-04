
@isTest
private class PlatformCacheRecipes_2_Tests {

    @isTest
    static void testStoreValueInSessionCache_HappyPath() {
        String key = 'TestKey';
        String value = 'TestValue';
        Integer ttl = 1800; // 30 minutes

        Test.startTest();
        PlatformCacheRecipes.storeValueInSessionCache(key, value, ttl);
        Test.stopTest();

        String cachedValue = PlatformCacheRecipes.getValueFromSessionCache(key);
        System.assertEquals(value, cachedValue, 'The cached value should match the stored value');
    }

    @isTest
    static void testStoreValueInSessionCache_NullKey() {
        String key = null;
        String value = 'TestValue';
        Integer ttl = 1800;

        Test.startTest();
        try {
            PlatformCacheRecipes.storeValueInSessionCache(key, value, ttl);
            System.assert(false, 'An exception should have been thrown for null key');
        } catch (cache.InvalidParamException e) {
            System.assert(e.getMessage().contains('Invalid Key'), 'Expected an InvalidParamException for null key');
        }
        Test.stopTest();
    }

    @isTest
    static void testStoreValueInSessionCache_NullValue() {
        String key = 'TestKey';
        String value = null;
        Integer ttl = 1800;

        Test.startTest();
        try {
            PlatformCacheRecipes.storeValueInSessionCache(key, value, ttl);
            System.assert(false, 'An exception should have been thrown for null value');
        } catch (cache.InvalidParamException e) {
            System.assert(e.getMessage().contains('Value cannot be null'), 'Expected an InvalidParamException for null value');
        }
        Test.stopTest();
    }

    @isTest
    static void testStoreValueInSessionCache_ExceedsMaxTTL() {
        String key = 'TestKey';
        String value = 'TestValue';
        Integer ttl = 28801; // 8 hours and 1 second

        Test.startTest();
        try {
            PlatformCacheRecipes.storeValueInSessionCache(key, value, ttl);
            System.assert(false, 'An exception should have been thrown for exceeding max TTL');
        } catch (cache.Org.OrgCacheException e) {
            System.assert(e.getMessage().contains('above maximum allowed'), 'Expected an OrgCacheException for exceeding max TTL');
        }
        Test.stopTest();
    }
}
