
@isTest
private class IterationRecipes_1_Tests {

    @testSetup
    static void setupTestData() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        List<Account> accounts = new List<Account>{
            new Account(Name='Test Account 1', NumberOfEmployees=10),
            new Account(Name='Test Account 2', NumberOfEmployees=20),
            new Account(Name='Test Account 3', NumberOfEmployees=null)
        };
        insert accounts;
    }

    @isTest
    static void testHappyPath() {
        List<Account> accounts = [SELECT Name, NumberOfEmployees FROM Account];
        Integer expectedSum = 30;
        Integer actualSum = IterationRecipes.iterateOnAccountList(accounts);
        System.assertEquals(expectedSum, actualSum, 'The sum should be 30.');
    }

    @isTest
    static void testSadPath() {
        List<Account> accounts = [SELECT Name, NumberOfEmployees FROM Account];
        accounts.add(new Account(NumberOfEmployees = null));
        Integer expectedSum = 30;
        Integer actualSum = IterationRecipes.iterateOnAccountList(accounts);
        System.assertEquals(expectedSum, actualSum, 'The sum should still be 30 since null is ignored.');
    }

    @isTest
    static void testEmptyList() {
        List<Account> accounts = new List<Account>();
        Integer expectedSum = 0;
        Integer actualSum = IterationRecipes.iterateOnAccountList(accounts);
        System.assertEquals(expectedSum, actualSum, 'The sum should be 0 for an empty account list.');
    }

    @isTest
    static void testNullList() {
        List<Account> accounts = null;
        try {
            Integer actualSum = IterationRecipes.iterateOnAccountList(accounts);
            System.assert(false, 'A NullPointerException should have been thrown.');
        } catch (NullPointerException e) {
            System.assert(true, 'NullPointerException was thrown as expected.');
        }
    }
}
