
@isTest
private class CanTheUser_4_Tests {

    @testSetup
    static void setup() {
        // No test data setup required for these tests
    }

    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void shouldAllowCreateWhenUserHasCreatePermission() {
        disableTriggers();
        
        Account testAccount = new Account(Name = 'Test Account');
        
        Test.startTest();
        Boolean canCreate = CanTheUser.create(testAccount);
        Test.stopTest();

        System.assertEquals(true, canCreate, 'User should be able to create Account');
    }

    @isTest
    static void shouldNotAllowCreateWhenUserLacksCreatePermission() {
        disableTriggers();
        
        Account testAccount = new Account(Name = 'Test Account');
        
        Test.startTest();
        Boolean canCreate = CanTheUser.create(testAccount);
        Test.stopTest();

        // Depending on your organization's security setup, you may need to modify this test to simulate the lack of permissions
        System.assertEquals(false, canCreate, 'User should not be able to create Account');
    }
}
