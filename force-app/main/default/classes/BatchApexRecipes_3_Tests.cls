
@isTest
private class BatchApexRecipes_3_Tests {
    
    // Utility method to create test data for accounts
    @testSetup
    static void setup() {
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
    }
    
    // Test method for Happy Path Scenario
    @isTest
    static void testBatchFinishWithSuccessAndFailures() {
        // Arrange
        BatchApexRecipes batchInstance = new BatchApexRecipes();
        batchInstance.throwError = false;
        
        // Act
        Test.startTest();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        Database.executeBatch(batchInstance);
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, BatchApexRecipes.result, 'The result should not be null.');
        System.assert(BatchApexRecipes.result.contains('Successes: '), 'The result should contain success count.');
    }
    
    // Test method for Sad Path Scenario
    @isTest
    static void testBatchFinishWithAllFailures() {
        // Arrange
        BatchApexRecipes batchInstance = new BatchApexRecipes();
        batchInstance.throwError = true;
        
        // Act
        Test.startTest();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        Database.executeBatch(batchInstance);
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, BatchApexRecipes.result, 'The result should not be null.');
        System.assert(BatchApexRecipes.result.contains('Failures: '), 'The result should contain failure count.');
    }
}
