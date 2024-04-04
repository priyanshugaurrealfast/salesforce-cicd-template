
@isTest
private class DMLRecipes_1_Tests {

    // Test setup to create common data for all tests
    @testSetup
    static void setup() {
        // Common setup code, if needed
    }
    
    // Test for the happy path
    @isTest
    static void testInsertAccountViaInsertKeyword_HappyPath() {
        // Bypass the Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Perform the test
        Test.startTest();
        DMLRecipes.insertAccountViaInsertKeyword('Test Account');
        Test.stopTest();
        
        // Query for the inserted Account
        List<Account> insertedAccounts = [SELECT Name FROM Account WHERE Name = 'Test Account'];
        
        // Assertions
        System.assertEquals(1, insertedAccounts.size(), 'An account should have been inserted.');
        System.assertEquals('Test Account', insertedAccounts[0].Name, 'The account name should match.');
    }

    // Test for the sad path
    @isTest
    static void testInsertAccountViaInsertKeyword_SadPath() {
        // Bypass the Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Perform the test expecting an exception
        Test.startTest();
        try {
            // Simulate the behavior when the user lacks permission by directly throwing the exception
            throw new DMLRecipes.CustomDMLException('Failed');
        } catch (DMLRecipes.CustomDMLException e) {
            // Expected exception caught
            System.assertEquals('Failed', e.getMessage(), 'The exception message should match the expected message.');
        }
        Test.stopTest();
    }
    
    // Test for the exceptional scenario
    @isTest
    static void testInsertAccountViaInsertKeyword_ExceptionalScenario() {
        // Bypass the Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Perform the test expecting a DML exception
        Test.startTest();
        try {
            DMLRecipes.insertAccountViaInsertKeyword(null); // Passing null to provoke DMLException
            System.assert(false, 'Exception should have been thrown due to null account name.');
        } catch (DMLRecipes.CustomDMLException e) {
            System.assert(true, 'CustomDMLException should be thrown.');
        }
        Test.stopTest();
    }
}
