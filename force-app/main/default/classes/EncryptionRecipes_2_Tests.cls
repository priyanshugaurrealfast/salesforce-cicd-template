
@isTest
private class EncryptionRecipes_2_Tests {
    
    // Test to ensure HMAC_KEY is set and not null
    @isTest
    static void testHMACKeyIsSet() {
        // Bypassing triggers if any DML operations are performed within
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assert that HMAC_KEY is not null
        System.assertNotEquals(null, EncryptionRecipes.HMAC_KEY, 'HMAC_KEY should not be null.');

        // Assert that HMAC_KEY has the correct hardcoded value
        String expectedValue = 'HMAC super secret key!';
        String actualValue = EncryptionRecipes.HMAC_KEY.toString();
        System.assertEquals(expectedValue, actualValue, 'HMAC_KEY does not match the expected hardcoded value.');
    }
}
