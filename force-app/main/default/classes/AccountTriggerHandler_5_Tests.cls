
@isTest
private class AccountTriggerHandler_5_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Account acc = new Account(Name='Test Account');
        insert acc;
        // Prepare for deletion to fire the trigger logic
        delete acc;
    }

    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testSuccessfullyClonesAndInsertsAccounts() {
        bypassTriggers();

        // Query deleted account for Testing
        List<Account> deletedAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' ALL ROWS];
        
        Test.startTest();
        // Perform undelete operation to fire the beforeDelete trigger
        undelete deletedAccounts;
        Test.stopTest();
        
        // Assert that original account is restored
        List<Account> restoredAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        System.assertEquals(2, restoredAccounts.size(), 'There should be two accounts: original and cloned');

        // Assert that a clone was inserted
        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Name = 'Test Account' AND Id NOT IN :deletedAccounts], 'Exactly one clone should have been inserted');
    }

    @isTest
    static void testDMLExceptionOccursDuringCloning() {
        bypassTriggers();
        AccountTriggerHandler.circuitBreaker = new DmlException();

        // Query deleted accounts for Testing
        List<Account> deletedAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' ALL ROWS];
        
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            // Perform undelete operation to fire the beforeDelete trigger
            undelete deletedAccounts;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        // Assert that an exception was caught
        System.assertEquals(true, exceptionThrown, 'An exception should have been thrown during the cloning process');

        // Reset circuitBreaker for other tests
        AccountTriggerHandler.circuitBreaker = null;
    }
}
