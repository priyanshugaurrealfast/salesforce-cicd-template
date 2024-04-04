
@isTest
public class PlatformCacheRecipes_3_Tests {
    @testSetup
    static void setup() {
        // Store a value in the Session cache for the happy path scenario
        PlatformCacheRecipes.storeValueInSessionCache('testKey', 'testValue');
    }

    @isTest
    static void testGetValueFromSessionCache_HappyPath() {
        // Retrieve a value from the cache
        String cachedValue = PlatformCacheRecipes.getValueFromSessionCache('testKey');

        // Assertions
        System.assertNotEquals(null, cachedValue, 'The cachedValue should not be null.');
        System.assertEquals('testValue', cachedValue, 'The cachedValue should be "testValue".');
    }

    @isTest
    static void testGetValueFromSessionCache_SadPath() {
        // Attempt to retrieve a value that does not exist in the cache
        String cachedValue = PlatformCacheRecipes.getValueFromSessionCache('nonexistentKey');

        // Assertions
        System.assertNotEquals(null, cachedValue, 'The cachedValue should not be null.');
        System.assertEquals('Cache Miss', cachedValue, 'The cachedValue should be "Cache Miss".');
    }
}
