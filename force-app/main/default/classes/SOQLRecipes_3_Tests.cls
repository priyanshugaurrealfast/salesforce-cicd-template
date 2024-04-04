
@isTest
private class SOQLRecipes_3_Tests {

    @testSetup
    static void setup() {
        // Disable triggers before creating test data
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create more than 200 Accounts to ensure chunking occurs
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 205; i++) {
            testAccounts.add(new Account(Name='TestAccount' + i));
        }
        insert testAccounts;
    }

    // Happy Path: test method to check if chunking works correctly
    @isTest
    static void testGetChunksOfLargeNumbersOfRecordsWithMultipleChunks() {
        // Execute the method
        Integer[] chunkInfo = SOQLRecipes.getChunksOfLargeNumbersOfRecords();
        
        // Assert there is more than one chunk
        System.assert(chunkInfo[0] > 1, 'Number of chunks should be greater than 1');
        // Assert total records are equal to 205
        System.assertEquals(205, chunkInfo[1], 'Total record count should be 205');
    }
}
