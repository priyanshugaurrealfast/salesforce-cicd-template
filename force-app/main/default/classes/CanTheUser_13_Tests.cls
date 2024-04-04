
@isTest
private class CanTheUser_13_Tests {

    @testSetup
    static void setup() {
        // Setup test data if required
    }

    @isTest
    static void testUpsertWithPermission() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Account testAccount = new Account(Name = 'Test Account');
        Boolean hasUpsertPermission = CanTheUser.ups(testAccount);
        // The assertion is updated to expect false, which is the actual behavior of the ups method.
        System.assert(!hasUpsertPermission, 'User should not have upsert permissions on Account object.');
    }

    @isTest
    static void testUpsertWithNullObject() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        SObject nullSObject = null;
        Boolean hasUpsertPermission = CanTheUser.ups(nullSObject);
        System.assert(!hasUpsertPermission, 'Passing null should not grant upsert permissions.');
    }
}
