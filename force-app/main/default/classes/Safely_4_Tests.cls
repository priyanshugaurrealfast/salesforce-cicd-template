
@isTest
private class Safely_4_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    private static Account getTestAccountData() {
        return [SELECT Id, Name FROM Account LIMIT 1];
    }
    
    @isTest
    static void testSuccessfulInsert() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Prepare test data
        Account testAccount = getTestAccountData();
        testAccount.Name = 'Updated Test Account';
        
        // Perform test
        Safely safelyInstance = new Safely();
        List<Database.SaveResult> results = safelyInstance.doInsert(testAccount);
        
        // Assert
        System.assertEquals(1, results.size(), 'One result should be returned.');
        System.assertEquals(true, results[0].isSuccess(), 'The insert operation should be successful.');
    }
    
    @isTest
    static void testInsertEmptyObject() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Perform test
        Safely safelyInstance = new Safely();
        List<Database.SaveResult> results = safelyInstance.doInsert(new Account());
        
        // Assert
        System.assertEquals(1, results.size(), 'One result should be returned for an empty object.');
    }
}
