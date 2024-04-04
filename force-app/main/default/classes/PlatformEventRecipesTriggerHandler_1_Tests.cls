
@isTest
private class PlatformEventTriggerTests {

    @testSetup
    static void makeTestData() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Event_Recipes_Demo__e testEvent = new Event_Recipes_Demo__e(
            accountId__c = testAccount.Id,
            title__c = 'Test Event',
            url__c = 'http://test.com'
        );
        insert testEvent;
    }

    private static void disableAccountTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testAfterInsertUpdatesAccountWebsite() {
        disableAccountTriggers();

        Test.startTest();
        List<Event_Recipes_Demo__e> events = new List<Event_Recipes_Demo__e>{
            new Event_Recipes_Demo__e(
                accountId__c = [SELECT Id FROM Account LIMIT 1].Id,
                title__c = 'Test Update Website',
                url__c = 'http://example.com'
            )
        };
        insert events;
        Test.stopTest();

        List<Account> updatedAccounts = [SELECT Website FROM Account WHERE Id = :events[0].accountId__c];
        System.assertEquals(1, updatedAccounts.size(), 'One Account should be retrieved.');
        System.assertEquals('http://example.com', updatedAccounts[0].Website, 'Account Website should be updated.');
    }

    @isTest
    static void testAfterInsertWithNoAccountIdDoesNotUpdateAccountWebsite() {
        disableAccountTriggers();

        Account preUpdateAccount = [SELECT Website FROM Account LIMIT 1];
        String originalWebsite = preUpdateAccount.Website;

        Test.startTest();
        Event_Recipes_Demo__e eventWithNoAccountId = new Event_Recipes_Demo__e(
            title__c = 'Test Without AccountId',
            url__c = 'http://shouldnotupdate.com'
        );
        insert eventWithNoAccountId;
        Test.stopTest();

        Account postUpdateAccount = [SELECT Website FROM Account WHERE Id = :preUpdateAccount.Id];
        System.assertEquals(originalWebsite, postUpdateAccount.Website, 'Account Website should not be updated as AccountId is missing in the event.');
    }
}
