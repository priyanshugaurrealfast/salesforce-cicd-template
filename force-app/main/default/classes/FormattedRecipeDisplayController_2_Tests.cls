
@isTest
public class FormattedRecipeDisplayController_2_Tests {

    @isTest
    static void testValidRecipeName() {
        // Given
        String validRecipeName = 'TestRecipe'; // Assume this ApexClass exists in the test org

        // When
        Test.startTest();
        FormattedRecipeDisplayController.ClassData result = FormattedRecipeDisplayController.getRecipeCode(validRecipeName);
        Test.stopTest();

        // Then
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(validRecipeName, result.name, 'The recipe name should match the test data');
    }

    @isTest
    static void testInvalidRecipeName() {
        // Given
        String invalidRecipeName = 'InvalidRecipe';
        Exception actualException;

        // When
        Test.startTest();
        try {
            FormattedRecipeDisplayController.ClassData result = FormattedRecipeDisplayController.getRecipeCode(invalidRecipeName);
        } catch (Exception e) {
            actualException = e;
        }
        Test.stopTest();

        // Then
        System.assert(actualException != null, 'An exception should be thrown for an invalid recipe name');
    }

    @isTest
    static void testNullRecipeName() {
        // Given
        String nullRecipeName = null;
        Exception actualException;

        // When
        Test.startTest();
        try {
            FormattedRecipeDisplayController.ClassData result = FormattedRecipeDisplayController.getRecipeCode(nullRecipeName);
        } catch (Exception e) {
            actualException = e;
        }
        Test.stopTest();

        // Then
        System.assert(actualException != null, 'An exception should be thrown for a null recipe name');
    }

    @isTest
    static void testRecipeNameWithWhitespace() {
        // Given
        String recipeNameWithWhitespace = '  TestRecipe  '; // Assume this name with whitespace will match 'TestRecipe' in the test org
        Exception actualException;

        // When
        Test.startTest();
        try {
            FormattedRecipeDisplayController.ClassData result = FormattedRecipeDisplayController.getRecipeCode(recipeNameWithWhitespace);
        } catch (Exception e) {
            actualException = e;
        }
        Test.stopTest();

        // Then
        System.assert(actualException != null, 'An exception should be thrown when no matching class is found due to whitespace');
    }
}
