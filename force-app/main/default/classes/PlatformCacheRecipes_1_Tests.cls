
@isTest
private class PlatformCacheRecipes_1_Tests {

    @testSetup
    static void setup() {
        // Custom setup if needed (in this case, no object setup required)
    }

    @isTest
    static void testStoreValueInSessionCache_Success() {
        String testKey = 'testKey';
        String testValue = 'testValue';
        
        Test.startTest();
        PlatformCacheRecipes.storeValueInSessionCache(testKey, testValue);
        Test.stopTest();
        
        String cachedValue = PlatformCacheRecipes.getValueFromSessionCache(testKey);
        
        System.assertEquals(testValue, cachedValue, 'The value was not stored in the session cache correctly.');
    }

    @isTest
    static void testStoreValueInSessionCache_NullKey() {
        String testKey = null;
        String testValue = 'testValue';
        
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            PlatformCacheRecipes.storeValueInSessionCache(testKey, testValue);
            Test.stopTest();
        } catch (cache.InvalidParamException e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'An exception should have been thrown for a null key.');
    }

    @isTest
    static void testStoreValueInSessionCache_NullValue() {
        String testKey = 'testKey';
        String testValue = null;

        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            PlatformCacheRecipes.storeValueInSessionCache(testKey, testValue);
            Test.stopTest();
        } catch (cache.InvalidParamException e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'An exception should have been thrown for a null value.');
    }
}
