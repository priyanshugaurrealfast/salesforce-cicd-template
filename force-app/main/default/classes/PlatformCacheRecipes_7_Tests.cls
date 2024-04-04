
@isTest
public class PlatformCacheRecipes_7_Tests {

    @testSetup
    static void setup() {
        // Since we're testing cache behavior, we don't need to set up any sObject records.
        // However, we will pre-fill the cache with a value for the happy path test.
        String key = 'testKey';
        String value = 'testValue';
        PlatformCacheRecipes.storeValueInOrgCache(key, value);
    }

    @isTest
    static void testGetValueFromOrgCache_HappyPath() {
        // Given
        String key = 'testKey';
        String expectedValue = 'testValue';

        // When
        String actualValue = PlatformCacheRecipes.getValuefromOrgCache(key);

        // Then
        System.assert(actualValue != null, 'Cache should return a non-null string.');
        System.assertEquals(expectedValue, actualValue, 'Cache should return the correct value.');
    }

    @isTest
    static void testGetValueFromOrgCache_SadPath() {
        // Given
        String missingKey = 'missingTestKey';
        String expectedMessage = 'Cache Miss';

        // When
        String actualValue = PlatformCacheRecipes.getValuefromOrgCache(missingKey);

        // Then
        System.assertNotEquals(null, actualValue, 'Cache should return a non-null string for missing keys.');
        System.assertEquals(expectedMessage, actualValue, 'Cache should return "Cache Miss" for missing keys.');
    }

    // Exceptional Scenario is not testable with a unit test since Platform Cache failures cannot be simulated.
    // Normally, we would also create a test for the exception path, but since it's not possible to simulate cache service downtime,
    // there's no need for a test method for the exceptional scenario.
}
