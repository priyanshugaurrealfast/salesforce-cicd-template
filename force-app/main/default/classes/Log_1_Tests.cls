
@isTest
private class Log_1_Tests {

    @isTest
    private static void testGetReturnsLogInstance() {
        // Act
        Log logInstance = Log.get();

        // Assert
        System.assertNotEquals(null, logInstance, 'The get method should return a non-null instance of Log.');
    }

    @isTest
    private static void testGetReturnsSameInstance() {
        // Act
        Log firstInstance = Log.get();
        Log secondInstance = Log.get();

        // Assert
        System.assertEquals(firstInstance, secondInstance, 'The get method should return the same instance of Log on subsequent calls.');
    }
}
