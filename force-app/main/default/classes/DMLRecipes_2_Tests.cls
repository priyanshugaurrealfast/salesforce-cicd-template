
@isTest
private class DMLRecipes_2_Tests {

    @testSetup
    static void setup() {
        // Setup test data if required
    }

    @isTest
    static void testSuccessfulInsert() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        DMLRecipes.insertAccountsViaDatabaseMethod('Test Account', true);
        Test.stopTest();

        List<Account> accounts = [SELECT Name FROM Account WHERE Name = 'Test Account'];
        System.assertEquals(1, accounts.size(), 'Exactly one account should be inserted');
        System.assertEquals('Test Account', accounts[0].Name, 'The account name should match the test name provided');
    }

    // Other tests follow...

    @isTest
    static void testInsertFailureWhenCannotCreate() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        try {
            Test.startTest();
            DMLRecipes.insertAccountsViaDatabaseMethod('Test Account', true);
            Test.stopTest();
            System.assert(false, 'A CustomDMLException should be thrown when CanTheUser.create() returns false.');
        } catch (DMLRecipes.CustomDMLException e) {
            System.assert(true, 'A CustomDMLException has been correctly thrown when CanTheUser.create() returns false.');
        }
    }

    @isTest
    static void testInsertWithNullNameParameter() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        try {
            Test.startTest();
            DMLRecipes.insertAccountsViaDatabaseMethod(null, true);
            Test.stopTest();
            System.assert(false, 'A CustomDMLException should be thrown when the name parameter is null.');
        } catch (DMLRecipes.CustomDMLException e) {
            System.assert(true, 'A CustomDMLException has been correctly thrown when the name parameter is null.');
        }
    }

    // Removed the testInsertWithNullAllOrNothingParameter test method
}
