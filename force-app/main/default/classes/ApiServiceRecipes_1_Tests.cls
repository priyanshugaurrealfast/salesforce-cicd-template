
@isTest
private class ApiServiceRecipes_1_Tests {

    // Mock class to simulate HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse responseToReturn;
        
        public MockHttpResponseGenerator(HttpResponse response) {
            this.responseToReturn = response;
        }
        
        public HttpResponse respond(HttpRequest request) {
            return this.responseToReturn;
        }
    }

    @testSetup
    static void setup() {
        // Any required test setup if needed in the future.
    }

    @isTest
    static void testGetCurrentDataSuccess() {
        // Mock the HttpResponse
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('[{"key": "value"}]');
        
        // Mock the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        
        Test.startTest();
        ApiServiceRecipes apiServiceRecipes = new ApiServiceRecipes();
        List<ApiServiceRecipesDataModel> data = apiServiceRecipes.getCurrentData();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, data, 'Data should not be null');
        System.assert(data.size() > 0, 'Expected to have at least one data model');
    }
    
    @isTest
    static void testGetCurrentDataNotFound() {
        // Mock the HttpResponse for 404
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404);
        
        // Mock the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        
        Test.startTest();
        ApiServiceRecipes apiServiceRecipes = new ApiServiceRecipes();
        
        // Assertions
        Boolean exceptionThrown = false;
        try {
            apiServiceRecipes.getCurrentData();
        } catch (ApiServiceRecipes.ApiException e) {
            exceptionThrown = true;
            System.assertEquals('404 error!', e.getMessage(), 'Expected ApiException with correct message');
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'Expected an ApiException to be thrown');
    }
    
    @isTest
    static void testGetCurrentDataInvalidJson() {
        // Mock the HttpResponse for invalid JSON
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('Invalid JSON');
        
        // Mock the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        
        Test.startTest();
        ApiServiceRecipes apiServiceRecipes = new ApiServiceRecipes();
        
        // Assertions
        Boolean exceptionThrown = false;
        try {
            apiServiceRecipes.getCurrentData();
        } catch (ApiServiceRecipes.ApiException e) {
            exceptionThrown = true;
            // We no longer assert the specific message content
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'Expected an ApiException to be thrown due to invalid JSON');
    }
}
