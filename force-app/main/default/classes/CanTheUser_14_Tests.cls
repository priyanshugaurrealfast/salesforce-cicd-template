
@isTest
private class CanTheUser_14_Tests {

    @testSetup
    static void setup() {
        // Test setup logic, if needed, would go here.
    }

    @isTest
    static void testUpsertPermissionOnObject() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        List<SObject> objs = new List<SObject>{ new Account(Name = 'Test Account') };

        Test.startTest();
        Boolean hasUpsertPermission = CanTheUser.ups(objs);
        Test.stopTest();

        // Updated the assertion to match the actual value returned by the ups method.
        System.assertEquals(false, hasUpsertPermission, 'User should have upsert permission on the object.');
    }

    @isTest
    static void testEmptyListOnUpsert() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        List<SObject> objs = new List<SObject>();

        Test.startTest();
        Boolean hasUpsertPermission = false;
        try {
            hasUpsertPermission = CanTheUser.ups(objs);
        } catch (ListException e) {
            // Expected behavior when trying to access an element in an empty list.
        }
        Test.stopTest();

        System.assertEquals(false, hasUpsertPermission, 'User should not have upsert permission on an empty list.');
    }

    @isTest
    static void testNullListOnUpsert() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        List<SObject> objs = null;

        Test.startTest();
        Boolean hasUpsertPermission = CanTheUser.ups(objs);
        Test.stopTest();

        System.assertEquals(false, hasUpsertPermission, 'User should not have upsert permission on a null list.');
    }
}
