
@isTest
private class StripInaccessibleRecipes_1_Tests {

    // Set up test data once for all tests
    @testSetup
    static void makeTestData() {
        List<Campaign> campaigns = new List<Campaign>();
        for (Integer i = 0; i < 5; i++) {
            campaigns.add(new Campaign(
                Name = 'Test Campaign ' + i,
                BudgetedCost = 50000 + (i * 1000),
                ActualCost = 45000 + (i * 1000)
            ));
        }
        insert campaigns;
    }
    
    private static void bypassTriggers() {
        // Bypassing triggers as per the project-specific framework
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        // If there is a campaign trigger handler, we would bypass it here
    }

    // Happy path test when the user has access to all fields
    @isTest
    static void testWithAccessToAllFields() {
        bypassTriggers();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            List<Campaign> campaigns = StripInaccessibleRecipes.stripInaccessibleFromQuery();
            System.assertEquals(5, campaigns.size(), 'Should return all campaigns');
            System.assertNotEquals(null, campaigns[0].Name, 'Campaign Name should be accessible');
        }
    }
}
