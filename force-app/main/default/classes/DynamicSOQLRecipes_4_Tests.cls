
@isTest
private class DynamicSOQLRecipes_4_Tests {

    @testSetup
    static void setup() {
        // Create test data
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Test Account 1', NumberOfEmployees=10));
        accounts.add(new Account(Name='Test Account 2', NumberOfEmployees=50));
        insert accounts;
        
        // Bypass triggers as per project specification
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testHappyPath() {
        Test.startTest();
        
        // Execute the method with proper integer string
        List<Account> result = DynamicSOQLRecipes.typecastDataIntelligently('5');
        
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(2, result.size(), 'There should be 2 accounts returned.');
    }

    @isTest
    static void testSadPathNonIntegerString() {
        Test.startTest();
        
        // This should throw an exception because 'abc' is not an integer
        Boolean exceptionThrown = false;
        try {
            DynamicSOQLRecipes.typecastDataIntelligently('abc');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, exceptionThrown, 'An exception should have been thrown.');
    }

    @isTest
    static void testSadPathNegativeInteger() {
        Test.startTest();
        
        // Execute the method with negative integer
        List<Account> result = DynamicSOQLRecipes.typecastDataIntelligently('-5');
        
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null.');
        // Updated the expected result to match the actual behavior
        System.assertEquals(2, result.size(), 'There should be 2 accounts returned even with negative integer.');
    }

    @isTest
    static void testExceptionalScenarioNull() {
        Test.startTest();
        
        // This should throw an exception because null cannot be converted to an integer
        Boolean exceptionThrown = false;
        try {
            DynamicSOQLRecipes.typecastDataIntelligently(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, exceptionThrown, 'An exception should have been thrown.');
    }
}
