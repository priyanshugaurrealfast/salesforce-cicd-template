
@isTest
private class CanTheUser_5_Tests {

    // Utilize the @testSetup annotation to create test data
    @testSetup
    static void setupData() {
        // Prepare test data if required. In this case, no data setup is required.
    }

    // Helper method to disable triggers
    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    // Test when the user has create permission on the SObject type
    @isTest
    static void testCreatePermission() {
        disableTriggers();
        List<SObject> objs = new List<SObject>{ new Account() };
        Test.startTest();
        Boolean canCreate = CanTheUser.create(objs);
        Test.stopTest();
        System.assert(canCreate, 'User should have create permission for the SObject type.');
    }

    // Test when the list is empty
    @isTest
    static void testEmptyList() {
        disableTriggers();
        List<SObject> objs = new List<SObject>{};
        Boolean canCreate;
        Test.startTest();
        try {
            canCreate = CanTheUser.create(objs);
        } catch (ListException e) {
            canCreate = false;
        }
        Test.stopTest();
        System.assert(!canCreate, 'User should not have create permission because the list is empty.');
    }

    // Test when the list is null
    @isTest
    static void testNullList() {
        disableTriggers();
        List<SObject> objs = null;
        Boolean canCreate;
        Test.startTest();
        try {
            canCreate = CanTheUser.create(objs);
        } catch (NullPointerException e) {
            canCreate = false;
        }
        Test.stopTest();
        System.assert(!canCreate, 'User should not have create permission because the list is null.');
    }

    // Test when the list has multiple SObjects
    @isTest
    static void testMultipleSObjects() {
        disableTriggers();
        List<SObject> objs = new List<SObject>{ new Account(), new Account() };
        Test.startTest();
        Boolean canCreate = CanTheUser.create(objs);
        Test.stopTest();
        System.assert(canCreate, 'User should have create permission based on the first SObject in the list.');
    }
}
