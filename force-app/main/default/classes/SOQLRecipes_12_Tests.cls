
@isTest
private class SOQLRecipes_12_Tests {

    @isTest
    static void testGetDetailsFromBothParentRecords_NoRecords() {
        // Assuming no Junction__c records exist in the org
        Test.startTest();
        List<Junction__c> results = SOQLRecipes.getDetailsFromBothParentRecords();
        Test.stopTest();
        
        // Verify that no Junction__c records are returned
        System.assertEquals(0, results.size(), 'There should be no Junction__c records returned.');
    }
}
