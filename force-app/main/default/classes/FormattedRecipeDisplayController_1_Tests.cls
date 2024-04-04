
@isTest
private class FormattedRecipeDisplayController_1_Tests {

    @isTest
    static void testWithStandardApexClass() {
        // Mock an ApexClass record
        ApexClass klass = new ApexClass(Name = 'StandardClass', ApiVersion = 52.0, Body = 'public class StandardClass {}', LengthWithoutComments = 30);
        FormattedRecipeDisplayController.ClassData classData = new FormattedRecipeDisplayController.ClassData(klass);

        System.assertEquals('StandardClass', classData.name, 'Class name should match');
        System.assertNotEquals('Tests', classData.groupName, 'Group name should not be Tests');
    }

    @isTest
    static void testWithApexTestClass() {
        // Mock an ApexClass record
        ApexClass klass = new ApexClass(Name = 'TestClass_Tests', ApiVersion = 52.0, Body = '@isTest class TestClass_Tests {}', LengthWithoutComments = 34);
        FormattedRecipeDisplayController.ClassData classData = new FormattedRecipeDisplayController.ClassData(klass);

        System.assertEquals('TestClass_Tests', classData.name, 'Class name should match');
        System.assertEquals('Tests', classData.groupName, 'Group name should be Tests');
    }

    @isTest
    static void testWithNullApexClass() {
        // We expect a NullPointerException to be thrown when null is passed to the constructor
        try {
            FormattedRecipeDisplayController.ClassData classData = new FormattedRecipeDisplayController.ClassData(null);
            System.assert(false, 'Expected a NullPointerException to be thrown.');
        } catch (NullPointerException e) {
            // If the exception is caught, the test passes, so no need for an assertion here
        }
    }
}
