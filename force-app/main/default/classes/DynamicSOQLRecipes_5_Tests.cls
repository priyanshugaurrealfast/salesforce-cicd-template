
@isTest
private class DynamicSOQLRecipes_5_Tests {

    @testSetup
    static void setup() {
        // Create test data
        List<Account> accounts = new List<Account>{
            new Account(Name='Test Account 1', NumberOfEmployees=10),
            new Account(Name='Test Account 2', NumberOfEmployees=20)
        };
        insert accounts;
    }
    
    // Test the happy path
    @isTest
    static void testSimpleQueryBuilderValidInput() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Define test data
        List<String> fields = new List<String>{'Name', 'NumberOfEmployees'};
        String whereClause = 'NumberOfEmployees > 5';
        
        // Perform test
        Test.startTest();
        List<Account> results = DynamicSOQLRecipes.simpleQueryBuilder(fields, whereClause);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, results.size(), 'Should return 2 accounts');
        System.assertEquals('Test Account 1', results[0].Name, 'First account name should match');
    }
    
    // Test the exceptional scenario with invalid field names
    @isTest
    static void testSimpleQueryBuilderInvalidFields() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Define test data with invalid field name
        List<String> fields = new List<String>{'InvalidField'};
        String whereClause = 'Name = \'Test Account 1\'';
        
        // Perform test and capture the error message
        String errorMessage = '';
        try {
            Test.startTest();
            List<Account> results = DynamicSOQLRecipes.simpleQueryBuilder(fields, whereClause);
            Test.stopTest();
        } catch (QueryException e) {
            errorMessage = e.getMessage();
        }
        
        // Assertions
        System.assertNotEquals('', errorMessage, 'Query with invalid fields should throw QueryException with a message.');
    }
}
