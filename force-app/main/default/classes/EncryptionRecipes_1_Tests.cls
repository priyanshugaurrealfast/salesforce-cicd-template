
@isTest
private class EncryptionRecipes_1_Tests {

    // Use testSetup to create test data if needed
    // However, for the static initialization, no test data setup is required

    @isTest
    static void testGenerateAESKey() {
        // Bypass triggers as required (even though there are no DML operations in this test)
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Test to ensure that the AES key is generated and has the correct length
        Test.startTest();
        Blob aesKey = EncryptionRecipes.AES_KEY;
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, aesKey, 'AES key should not be null');
        System.assertEquals(32, aesKey.size(), 'AES key length should be 32 bytes (256 bits)');
    }
}
