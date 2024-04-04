
@isTest
private class CalloutRecipes_8_Tests {
    @testSetup
    static void makeTestData() {
        // No specific test data required for callout tests since we are mocking responses
    }
    
    private static String getMockResponse() {
        // Shortened the ExternalSalesforceId__c value to 18 characters
        return '{' +
            '"Id": "0011r00002ABC12",' +
            '"Name": "Test Account",' +
            '"Website": "http://www.example.com",' +
            '"Contacts": [' +
                '{' +
                    '"FirstName": "John",' +
                    '"LastName": "Doe",' +
                    '"Email": "john.doe@example.com"' +
                '},' +
                '{' +
                    '"FirstName": "Jane",' +
                    '"LastName": "Doe",' +
                    '"Email": "jane.doe@example.com"' +
                '}' +
            ']' +
        '}';
    }

    @isTest
    static void testInsertAccountAndContactsFromValidResponse() {
        String validResponse = getMockResponse();
        CalloutRecipes calloutInstance = new CalloutRecipes('MockNamedCredential');
        
        Test.startTest();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        calloutInstance.insertAccountAndContactsFromUntypedResponse(validResponse);
        Test.stopTest();
        
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE ExternalSalesforceId__c = '0011r00002ABC12'];
        List<Contact> contacts = [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId = :accounts[0].Id];
        System.assertEquals(1, accounts.size(), 'One account should be inserted');
        System.assertEquals(2, contacts.size(), 'Two contacts should be related to the account');
    }

    @isTest
    static void testInsertAccountAndContactsFromInvalidResponse() {
        String invalidResponse = 'Invalid JSON String';
        CalloutRecipes calloutInstance = new CalloutRecipes('MockNamedCredential');
        Exception thrownException;
        
        Test.startTest();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        try {
            calloutInstance.insertAccountAndContactsFromUntypedResponse(invalidResponse);
        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();
        
        System.assertNotEquals(null, thrownException, 'An exception should be thrown due to invalid JSON');
    }

    @isTest
    static void testInsertAccountAndContactsFromResponseWithDmlError() {
        String missingRequiredFieldsResponse = '{' +
            '"Id": "0011r00002ABC12",' +
            '"Name": "Test Account",' +
            '"Contacts": [' +
                '{' +
                    '"FirstName": "John"' +
                '}' +
            ']' +
        '}';
        CalloutRecipes calloutInstance = new CalloutRecipes('MockNamedCredential');
        Exception thrownException;

        Test.startTest();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        try {
            calloutInstance.insertAccountAndContactsFromUntypedResponse(missingRequiredFieldsResponse);
        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();
        
        System.assertNotEquals(null, thrownException, 'An exception should be thrown due to missing required fields');
    }
}
