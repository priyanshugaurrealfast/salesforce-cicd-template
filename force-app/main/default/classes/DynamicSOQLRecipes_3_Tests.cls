
@isTest
private class DynamicSOQLRecipes_3_Tests {
    // Use @testSetup to create test data
    @testSetup
    static void setup() {
        // Disable Account triggers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    // Test method for Happy Path scenario
    @isTest
    static void testResolvedDynamicFieldsSOQLQuery_WithValidAccount() {
        // Retrieve the test data
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'Test Account' LIMIT 1];

        // Perform the test
        Test.startTest();
        List<Account> result = DynamicSOQLRecipes.resolvedDynamicFieldsSOQLQuery(testAccount);
        Test.stopTest();

        // Assertions
        System.assertEquals(1, result.size(), 'Should return one account');
        System.assertEquals(testAccount.Name, result[0].Name, 'Account name should match the test account');
    }

    // Test method for Sad Path scenario
    @isTest
    static void testResolvedDynamicFieldsSOQLQuery_WithNonExistingAccount() {
        // Create a non-existing account object
        Account fakeAccount = new Account(Name = 'Fake Account');

        // Perform the test
        Test.startTest();
        List<Account> result = DynamicSOQLRecipes.resolvedDynamicFieldsSOQLQuery(fakeAccount);
        Test.stopTest();

        // Assertions
        System.assertEquals(0, result.size(), 'Should return an empty list for non-existing account');
    }

    // Test method for Exceptional Scenario
    @isTest
    static void testResolvedDynamicFieldsSOQLQuery_WithNullAccount() {
        // Perform the test
        Exception actualException;
        try {
            Test.startTest();
            List<Account> result = DynamicSOQLRecipes.resolvedDynamicFieldsSOQLQuery(null);
            Test.stopTest();
        } catch (Exception e) {
            actualException = e;
        }

        // Assertions
        System.assertNotEquals(null, actualException, 'An exception should be thrown for null account');
        System.assertEquals('System.NullPointerException', actualException.getTypeName(), 'Expected a NullPointerException to be thrown');
    }
}
