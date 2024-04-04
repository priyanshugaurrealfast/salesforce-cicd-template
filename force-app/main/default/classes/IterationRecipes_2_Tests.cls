
@isTest
private class IterationRecipes_2_Tests {

    // Define a mock class for the IterableApiClient to simulate the API callout
    private class IterableApiClientMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake HTTPResponse
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('[{"records": ["Record1", "Record2", "Record3"]}]'); // Simulate a JSON response
            return response;
        }
    }
    
    // Define a mock class to simulate an exception being thrown when making the API callout
    private class IterableApiClientExceptionMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            // Throw an exception to simulate connectivity problems
            throw new CustomException('Simulated Exception');
        }
    }

    // Custom exception class
    private class CustomException extends Exception {}

    // Happy Path Test
    @isTest
    static void testIterableApiClientRecipe_HappyPath() {
        // Register the mock response
        Test.setMock(HttpCalloutMock.class, new IterableApiClientMock());
        
        // Execute the method and assert the results
        Test.startTest();
        List<String> result = IterationRecipes.iterableApiClientRecipe();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(3, result.size(), 'The size of the result list should be 3.');
    }

    // Exceptional Scenario Test
    @isTest
    static void testIterableApiClientRecipe_ExceptionalScenario() {
        // Register the mock response to throw an exception
        Test.setMock(HttpCalloutMock.class, new IterableApiClientExceptionMock());
        
        Boolean exceptionThrown = false;
        // Execute the method and catch the exception
        try {
            Test.startTest();
            List<String> result = IterationRecipes.iterableApiClientRecipe();
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            // Assertions
            System.assert(e instanceof CustomException, 'The exception should be a CustomException.');
            System.assertEquals('Simulated Exception', e.getMessage(), 'The exception message should match.');
        }
        
        // Confirm that an exception was thrown
        System.assert(exceptionThrown, 'An exception should have been thrown by the IterableApiClient.');
    }
}
