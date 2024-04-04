
@isTest
private class IterableApiClient_4_Tests {

    private class MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String status;
        private String body;
        
        public MockHttpResponse(Integer statusCode, String status, String body) {
            this.statusCode = statusCode;
            this.status = status;
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(this.statusCode);
            response.setStatus(this.status);
            response.setBody(this.body);
            return response;
        }
    }

    @testSetup
    static void setup() {
        // Setup is not needed in this case as no Salesforce records are required
        // for the API callout tests.
    }
    
    @isTest
    static void testGetRecordsSuccess() {
        // Mock a successful API response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, 'OK', '{"records":["Record1","Record2"],"totalRecordCount":2}'));
        
        Test.startTest();
        IterableApiClient client = new IterableApiClient('NamedCredentialName');
        Iterator<IterableApiClient.RecordPage> iterator = client.iterator();
        IterableApiClient.RecordPage recordPage = iterator.next();
        List<String> records = recordPage.getRecords();
        Test.stopTest();
        
        // Assert that the correct records are returned
        System.assertEquals(2, records.size(), 'There should be 2 records.');
        System.assertEquals('Record1', records[0], 'The first record should match.');
    }
    
    @isTest
    static void testGetRecordsEmptyList() {
        // Mock an API response with an empty record list
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, 'OK', '{"records":[],"totalRecordCount":0}'));
        
        Test.startTest();
        IterableApiClient client = new IterableApiClient('NamedCredentialName');
        Iterator<IterableApiClient.RecordPage> iterator = client.iterator();
        IterableApiClient.RecordPage recordPage = iterator.next();
        List<String> records = recordPage.getRecords();
        Test.stopTest();
        
        // Assert that an empty list is returned
        System.assertEquals(0, records.size(), 'There should be no records.');
    }
    
    @isTest
    static void testGetRecordsApiException() {
        // Mock a failed API response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(404, 'Not Found', ''));

        Boolean exceptionThrown = false;
        String exceptionMessage = '';
        Test.startTest();
        IterableApiClient client = new IterableApiClient('NamedCredentialName');
        Iterator<IterableApiClient.RecordPage> iterator = client.iterator();
        
        try {
            IterableApiClient.RecordPage recordPage = iterator.next();
        } catch (IterableApiClient.IterableApiException e) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }
        Test.stopTest();
        
        // Assert that an exception is thrown and the message is correct
        System.assert(exceptionThrown, 'An IterableApiException should have been thrown.');
        System.assertEquals('Failed to retrieve record page 0: HTTP 404 Not Found', exceptionMessage, 'The exception message should contain the HTTP status code and message.');
    }
}
