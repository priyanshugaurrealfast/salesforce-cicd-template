
@isTest
private class QuiddityRecipes_1_Tests {

    @isTest
    static void testDemonstrateGetQuiddityReturnsValue() {
        // Test to ensure that the demonstrateGetQuiddity method returns a non-null Quiddity value
        Test.startTest();
        System.Quiddity quidValue = QuiddityRecipes.demonstrateGetQuiddity();
        Test.stopTest();

        // Assert that the returned Quiddity value is not null
        System.assertNotEquals(null, quidValue, 'The Quiddity value should not be null');
    }
}
