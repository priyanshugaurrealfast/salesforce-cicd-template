
@isTest
private class CollectionUtils_1_Tests {

    @testSetup
    static void setupTestData() {
        // Bypass account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    }

    @isTest
    static void testIdMapFromCollectionByKey_HappyPath() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        Map<Id, SObject> result = CollectionUtils.idMapFromCollectionByKey('Id', accounts);

        System.assertEquals(accounts.size(), result.size(), 'The size of the result map should be equal to the number of accounts.');
        for (Account acc : accounts) {
            System.assertEquals(acc, result.get(acc.Id), 'The account in the map should match the original account.');
        }
    }

    @isTest
    static void testIdMapFromCollectionByKey_SadPath_EmptyList() {
        List<Account> accounts = new List<Account>();
        Map<Id, SObject> result = CollectionUtils.idMapFromCollectionByKey('Id', accounts);

        System.assertEquals(0, result.size(), 'The result map should be empty when the incoming list is empty.');
    }

    @isTest
    static void testIdMapFromCollectionByKey_SadPath_FieldNotPresent() {
        List<Account> accounts = [SELECT Id FROM Account];
        Boolean caughtException = false;
        try {
            Map<Id, SObject> result = CollectionUtils.idMapFromCollectionByKey('NonExistentField', accounts);
        } catch (SObjectException e) {
            caughtException = true;
        }
        
        System.assert(caughtException, 'An SObjectException should be thrown when the key is an invalid field name.');
    }

    @isTest
    static void testIdMapFromCollectionByKey_Exception_NullList() {
        Boolean caughtException = false;
        try {
            Map<Id, SObject> result = CollectionUtils.idMapFromCollectionByKey('Id', null);
        } catch (NullPointerException e) {
            caughtException = true;
        }
        
        System.assert(caughtException, 'A NullPointerException should be thrown when the incoming list is null.');
    }

    @isTest
    static void testIdMapFromCollectionByKey_Exception_InvalidFieldName() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        Boolean caughtException = false;
        try {
            Map<Id, SObject> result = CollectionUtils.idMapFromCollectionByKey('InvalidField', accounts);
        } catch (SObjectException e) {
            caughtException = true;
        }
        
        System.assert(caughtException, 'An SObjectException should be thrown when the key is an invalid field name.');
    }
}
