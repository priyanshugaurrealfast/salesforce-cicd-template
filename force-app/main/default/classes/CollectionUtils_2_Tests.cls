
@isTest
private class CollectionUtils_2_Tests {

    @testSetup
    static void makeTestData() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'TestAccount' + i));
        }
        insert testAccounts;
    }

    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testValidStringKeyMapFromCollection() {
        bypassTriggers();
        Test.startTest();
        List<Account> accounts = [SELECT Name FROM Account];
        Map<String, SObject> result = CollectionUtils.stringMapFromCollectionByKey('Name', accounts);
        Test.stopTest();
        System.assertEquals(5, result.size(), 'Map should contain all elements from list.');
        System.assertNotEquals(null, result.get('TestAccount1'), 'Map should have the element with the key.');
    }

    @isTest
    static void testInvalidKeyMapFromCollection() {
        bypassTriggers();

        Exception expectedException;
        try {
            Test.startTest();
            List<Account> accounts = [SELECT Name FROM Account];
            Map<String, SObject> result = CollectionUtils.stringMapFromCollectionByKey('InvalidKey', accounts);
            Test.stopTest();
        } catch (Exception e) {
            expectedException = e;
        }

        System.assert(expectedException instanceof System.SObjectException, 'Expected a System.SObjectException to be thrown for invalid key access.');
    }

    @isTest
    static void testEmptyListMapFromCollection() {
        bypassTriggers();
        Test.startTest();
        List<Account> accounts = new List<Account>();
        Map<String, SObject> result = CollectionUtils.stringMapFromCollectionByKey('Name', accounts);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Map should be empty because the list is empty.');
    }

    @isTest
    static void testDuplicateKeyValuesMapFromCollection() {
        bypassTriggers();
        List<Account> accounts = new List<Account>{
            new Account(Name = 'DuplicateName'),
            new Account(Name = 'DuplicateName')
        };
        insert accounts;
        Test.startTest();
        accounts = [SELECT Name FROM Account WHERE Name = 'DuplicateName'];
        Map<String, SObject> result = CollectionUtils.stringMapFromCollectionByKey('Name', accounts);
        Test.stopTest();
        System.assertEquals(1, result.size(), 'Map should contain only one element due to duplicate key.');
    }

    @isTest
    static void testNullKeyMapFromCollection() {
        bypassTriggers();

        Exception expectedException;
        try {
            Test.startTest();
            List<Account> accounts = [SELECT Name FROM Account];
            Map<String, SObject> result = CollectionUtils.stringMapFromCollectionByKey(null, accounts);
            Test.stopTest();
        } catch (Exception e) {
            expectedException = e;
        }

        System.assert(expectedException instanceof System.NullPointerException, 'Expected a System.NullPointerException to be thrown when key is null.');
    }
}
