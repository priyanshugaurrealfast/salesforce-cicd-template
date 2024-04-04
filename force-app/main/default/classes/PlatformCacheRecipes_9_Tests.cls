
@isTest
private class PlatformCacheRecipes_9_Tests {

    @isTest
    static void testGetDefaultPartitionForSession() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act
        Cache.Partition sessionPartition = PlatformCacheRecipes.getDefaultPartition(PlatformCacheRecipes.PartitionType.SESSION);

        // Assert
        System.assertNotEquals(null, sessionPartition, 'Session partition should not be null');
    }

    @isTest
    static void testGetDefaultPartitionForOrg() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act
        Cache.Partition orgPartition = PlatformCacheRecipes.getDefaultPartition(PlatformCacheRecipes.PartitionType.ORG);

        // Assert
        System.assertNotEquals(null, orgPartition, 'Org partition should not be null');
    }
}
