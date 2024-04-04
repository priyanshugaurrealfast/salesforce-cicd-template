
@isTest
private class IterableApiClient_2_Tests {

    @isTest
    static void testHasNextWhenTotalRecordCountIsNull() {
        IterableApiClient client = new IterableApiClient('MockCredential');
        IterableApiClient.RecordPageIterator iterator = (IterableApiClient.RecordPageIterator)client.iterator();
        
        // As we haven't started iterating, totalRecordCount should be null and hasNext should return true
        Boolean result = iterator.hasNext();
        System.assertEquals(true, result, 'hasNext should return true when totalRecordCount is null.');
    }

    @isTest
    static void testHasNextWithMoreRecordsToFetch() {
        // Setting totalRecordCount to simulate more records to fetch
        IterableApiClient client = new IterableApiClient('MockCredential');
        IterableApiClient.RecordPageIterator iterator = (IterableApiClient.RecordPageIterator)client.iterator();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        iterator.next(); // This should set the totalRecordCount and increment the currentPageIndex

        // Assuming that MockHttpResponseGenerator will set totalRecordCount > RESPONSE_PAGE_SIZE
        Boolean result = iterator.hasNext();
        System.assertEquals(true, result, 'hasNext should return true if more records are available to fetch.');
    }

    @isTest
    static void testHasNextWithNoMoreRecordsToFetch() {
        // Setting currentPageIndex and totalRecordCount to simulate no more records to fetch
        IterableApiClient client = new IterableApiClient('MockCredential');
        IterableApiClient.RecordPageIterator iterator = (IterableApiClient.RecordPageIterator)client.iterator();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Simulating iterating through all pages
        while(iterator.hasNext()) {
            iterator.next();
        }
        
        Boolean result = iterator.hasNext();
        System.assertEquals(false, result, 'hasNext should return false if no more records are available to fetch.');
    }
    
    // We would also need a mock implementation for the HttpCalloutMock to simulate HTTP responses for `.next()`
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"records":["record1","record2"], "totalRecordCount":20}');
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
}
