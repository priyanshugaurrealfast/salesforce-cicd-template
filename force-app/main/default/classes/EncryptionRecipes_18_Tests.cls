
@isTest
private class EncryptionRecipes_18_Tests {

    // Test method for two equal strings
    @isTest
    static void testEqualStrings() {
        String str1 = 'testString';
        String str2 = 'testString';

        Boolean areEqual = EncryptionRecipes.areEqualConstantTime(str1, str2);

        System.assertEquals(true, areEqual, 'The strings should be equal');
    }

    // Test method for two non-equal strings of the same length
    @isTest
    static void testNonEqualStringsSameLength() {
        String str1 = 'testString1';
        String str2 = 'testString2';

        Boolean areEqual = EncryptionRecipes.areEqualConstantTime(str1, str2);

        System.assertEquals(false, areEqual, 'The strings should not be equal');
    }

    // Test method for two non-equal strings of different lengths
    @isTest
    static void testNonEqualStringsDifferentLengths() {
        String str1 = 'testString';
        String str2 = 'testStringExtra';

        Boolean areEqual = EncryptionRecipes.areEqualConstantTime(str1, str2);

        System.assertEquals(false, areEqual, 'The strings should not be equal');
    }
}
