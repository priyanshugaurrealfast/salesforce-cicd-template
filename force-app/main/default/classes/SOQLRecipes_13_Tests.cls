
@isTest
private class SOQLRecipes_13_Tests {

    @testSetup
    static void setupTestData() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        List<Opportunity> oppList = new List<Opportunity> {
            new Opportunity(Name = 'Opportunity 1', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount.Id, Amount = 10000),
            new Opportunity(Name = 'Opportunity 2', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount.Id, Amount = 20000),
            new Opportunity(Name = 'Opportunity 3', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount.Id, Amount = 30000)
        };
        insert oppList;
    }

    @isTest
    static void testGetSumOfOpportunityRecords_HappyPath() {
        Test.startTest();
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Double sumOfOpportunities = SOQLRecipes.getSumOfOpportunityRecords(accountId);
        Test.stopTest();

        System.assertNotEquals(null, sumOfOpportunities, 'The sum should not be null');
        System.assertEquals(60000, sumOfOpportunities, 'The sum of opportunity amounts should be 60000');
    }

    @isTest
    static void testGetSumOfOpportunityRecords_SadPath() {
        Test.startTest();
        Account newAccount = new Account(Name = 'New Account');
        insert newAccount;
        Double sumOfOpportunities = SOQLRecipes.getSumOfOpportunityRecords(newAccount.Id);
        Test.stopTest();

        System.assertEquals(null, sumOfOpportunities, 'The sum should be null for an Account with no Opportunities');
    }

    @isTest
    static void testGetSumOfOpportunityRecords_ExceptionalScenario() {
        Test.startTest();
        Double sumOfOpportunities = SOQLRecipes.getSumOfOpportunityRecords(null);
        Test.stopTest();

        System.assertEquals(null, sumOfOpportunities, 'The sum should be null when passing an invalid accountId');
    }
}
