
@isTest
private class DataFactoryForPackageInstalls_1_Tests {

    @testSetup
    static void setup() {
        // Create test data if needed for the scenarios
        // Note: As the method itself generates the data, we may not need to set up data here.
    }

    @isTest
    static void testGenerateDataSuccess() {
        // Bypass the triggers as per the project-specific framework
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Call the method to test
        Test.startTest();
        DataFactoryForPackageInstalls.generateData();
        Test.stopTest();

        // Assert that the data was successfully created
        List<Junction_Demo_1__c> junc1List = [SELECT Id FROM Junction_Demo_1__c];
        List<Junction_Demo_2__c> junc2List = [SELECT Id FROM Junction_Demo_2__c];
        List<Junction__c> juncList = [SELECT Parent1__c, Parent2__c FROM Junction__c];

        System.assertEquals(50, junc1List.size(), '50 Junction_Demo_1__c records should be created.');
        System.assertEquals(50, junc2List.size(), '50 Junction_Demo_2__c records should be created.');
        System.assertEquals(50, juncList.size(), '50 Junction__c records should be created linking both.');
    }

    // Additional test methods for exceptional cases can be added here
}
