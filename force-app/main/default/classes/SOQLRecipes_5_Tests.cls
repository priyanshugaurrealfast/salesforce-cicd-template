
@isTest
public class SOQLRecipes_5_Tests {
    
    @testSetup
    static void setup() {
        // Bypass the trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test data
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name='Test Account US IN Fast Food', ShippingCountry='US', ShippingState='IN', Industry='Fast Food - made whole'));
        testAccounts.add(new Account(Name='Test Account US IN Slow Food', ShippingCountry='US', ShippingState='IN', Industry='Slow Food - Made quickly'));
        // Adding an account that should not be returned by the target method
        testAccounts.add(new Account(Name='Test Account Other', ShippingCountry='Canada', ShippingState='ON', Industry='Retail'));
        insert testAccounts;
    }
    
    @isTest
    static void testGetRecordsByMultipleFieldValues_WithResults() {
        Test.startTest();
        List<Account> accounts = SOQLRecipes.getRecordsByMultipleFieldValues();
        Test.stopTest();
        
        System.assertEquals(2, accounts.size(), 'There should be 2 qualifying accounts.');
        System.assertEquals('Test Account US IN Fast Food', accounts[0].Name, 'The account name should match the expected result.');
    }
    
    @isTest
    static void testGetRecordsByMultipleFieldValues_WithoutResults() {
        // Adjust test data to not match the query criteria
        List<Account> allAccounts = [SELECT Id, ShippingCountry FROM Account];
        for (Account acc : allAccounts) {
            acc.ShippingCountry = 'CA';
        }
        update allAccounts;
        
        Test.startTest();
        List<Account> accounts = SOQLRecipes.getRecordsByMultipleFieldValues();
        Test.stopTest();
        
        System.assertEquals(0, accounts.size(), 'There should be no accounts returned.');
    }
    
    // Testing exceptional scenarios would usually involve reaching limits or causing exceptions,
    // which is not practical or possible in many cases without complex mocking or other approaches.
}
