
@isTest
private class RestClient_3_Tests {
    
    @testSetup
    static void setup() {
        // Since the target method uses Named Credentials and does not
        // interact directly with Salesforce data, we do not need to set up any test data.
        // However, if we needed to set up test Accounts for instance, we would do it here,
        // and disable triggers as necessary:
        // TriggerHandler.bypass('AccountTriggerHandler');
        // TriggerHandler.bypass('MDTAccountTriggerHandler');
        // insert new Account(Name = 'Test Account');
    }

    @isTest
    static void testMakeApiCall_Success() {
        // Arrange
        String namedCredential = 'ValidNamedCredential';
        RestClient.HttpVerb method = RestClient.HttpVerb.GET;
        String path = '/valid/path';

        // Act
        Test.startTest();
        HttpResponse response = RestClient.makeApiCall(namedCredential, method, path);
        Test.stopTest();

        // Assert
        System.assertEquals(200, response.getStatusCode(), 'The status code should be 200');
        System.assert(response.getBody() != null, 'The response body should not be null');
    }

    @isTest
    static void testMakeApiCall_InvalidNamedCredential() {
        // Arrange
        String namedCredential = 'InvalidNamedCredential';
        RestClient.HttpVerb method = RestClient.HttpVerb.GET;
        String path = '/valid/path';

        Test.startTest();
        // Act & Assert
        try {
            HttpResponse response = RestClient.makeApiCall(namedCredential, method, path);
            System.assert(false, 'The callout should not be successful with an invalid named credential.');
        } catch (CalloutException e) {
            // The exception is expected in this case
            System.assert(e.getMessage().contains('Unauthorized endpoint'), 'An appropriate exception should be thrown for an invalid named credential.');
        }
        Test.stopTest();
    }

    @isTest
    static void testMakeApiCall_ExceptionScenario() {
        // Arrange
        String namedCredential = 'ValidNamedCredential';
        RestClient.HttpVerb method = RestClient.HttpVerb.GET;
        String path = '/valid/path';

        // Set up the mock to simulate an exception
        // Assuming there is a mock implementation that throws an exception
        // Test.setMock(HttpCalloutMock.class, new ExceptionThrowingMock());

        Test.startTest();
        // Act & Assert
        try {
            HttpResponse response = RestClient.makeApiCall(namedCredential, method, path);
            System.assert(false, 'The callout should fail and an exception should be caught.');
        } catch (Exception e) {
            // If an exception is thrown, it means the callout was not successful
            System.assert(e.getMessage().contains('Callout exception'), 'An appropriate exception should be thrown and handled.');
        }
        Test.stopTest();
    }
}
