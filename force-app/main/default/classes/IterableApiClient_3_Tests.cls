
@isTest
private class IterableApiClient_3_Tests {
    @testSetup
    static void setup() {
        // Test setup (not needed for this test case as we mock the responses)
    }

    private static IterableApiClient.RecordPageIterator getTestIterator() {
        IterableApiClient client = new IterableApiClient('TestNamedCredential');
        return (IterableApiClient.RecordPageIterator)client.iterator();
    }

    @isTest
    static void testNextMethodHappyPath() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Mocking HttpResponse
        HttpResponse response = new HttpResponse();
        response.setBody('{"records":["record1","record2"],"totalRecordCount":20}');
        response.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));

        // Act
        IterableApiClient.RecordPageIterator iterator = getTestIterator();
        System.assert(iterator.hasNext(), 'Iterator should have next available');
        IterableApiClient.RecordPage page = iterator.next();

        // Assert
        System.assertNotEquals(null, page, 'RecordPage should not be null');
        System.assertEquals(2, page.getRecords().size(), 'There should be two records on the page');
    }

    @isTest
    static void testNextMethodSadPath() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Mocking HttpResponse for failure scenario
        HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));

        // Act and Assert
        IterableApiClient.RecordPageIterator iterator = getTestIterator();
        Boolean exceptionThrown = false;
        try {
            iterator.next();
        } catch (IterableApiClient.IterableApiException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'An exception should have been thrown due to API error');
    }

    // Utility class for generating mock HttpResponses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse mockResponse;

        MockHttpResponseGenerator(HttpResponse response) {
            this.mockResponse = response;
        }

        public HttpResponse respond(HttpRequest request) {
            return mockResponse;
        }
    }
}
