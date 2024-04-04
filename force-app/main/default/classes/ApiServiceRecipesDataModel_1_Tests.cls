
@isTest
private class ApiServiceRecipesDataModel_1_Tests {

    @isTest
    static void testParseValidJson() {
        // Given
        String validJson = '[{"exampleArray":[1,2,3],"exampleBoolean":true,"exampleColor":"#FFF","exampleCouldBeNull":null,"exampleNumber":42,"exampleObject":{"a":"alpha","c":"gamma"},"exampleString":"Hello World"}]';
        
        // When
        List<ApiServiceRecipesDataModel> parsedList = ApiServiceRecipesDataModel.parse(validJson);
        
        // Then
        System.assertEquals(1, parsedList.size(), 'There should be exactly one parsed model');
        System.assertEquals('Hello World', parsedList[0].exampleString, 'The exampleString field should match the provided JSON string');
    }

    @isTest
    static void testParseInvalidStructureJson() {
        // Given
        String invalidStructureJson = '[{"invalidKey": "value", "anotherInvalidKey": "value"}]';
        
        // When
        Test.startTest();
        List<ApiServiceRecipesDataModel> parsedList = ApiServiceRecipesDataModel.parse(invalidStructureJson);
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, parsedList, 'The parsed list should not be null even if the structure is invalid');
        System.assertNotEquals(0, parsedList.size(), 'The parsed list should not be empty because deserialize will create an object with default/null values for missing keys');
        // Additional check to ensure that the fields are null or default values
        ApiServiceRecipesDataModel model = parsedList[0];
        System.assertEquals(null, model.exampleString, 'The exampleString field should be null due to invalid structure');
    }

    @isTest
    static void testParseMalformedJson() {
        // Given
        String malformedJson = 'This is not a JSON string';
        
        // When & Then
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            ApiServiceRecipesDataModel.parse(malformedJson);
        } catch (System.JSONException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'A System.JSONException should have been thrown due to malformed JSON');
    }
}
