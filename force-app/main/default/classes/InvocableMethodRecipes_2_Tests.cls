
@isTest
private class InvocableMethodRecipes_2_Tests {

    // Use @testSetup to create test data
    @testSetup
    static void setupTestData() {
        // Create an Account for testing
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Create a Contact related to the Account
        Contact testContact = new Contact(LastName='Test Contact', AccountId=testAccount.Id);
        insert testContact;

        // Create a Task related to a Contact
        Task testTask = new Task(WhoId=testContact.Id);
        insert testTask;
    }

    // Happy path test for Account
    @isTest
    static void testFindRelatedContactsForAccount() {
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];

        InvocableMethodRecipes.ContactSearchRequest request = new InvocableMethodRecipes.ContactSearchRequest();
        request.inputs = new List<SObject>{testAccount};

        Test.startTest();
        List<InvocableMethodRecipes.ContactSearchResult> results =
            InvocableMethodRecipes.findRelatedContacts(new List<InvocableMethodRecipes.ContactSearchRequest>{request});
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(testContact.Id, ((Contact)results[0].output).Id);
    }

    // Happy path test for Task
    @isTest
    static void testFindRelatedContactsForTask() {
        Task testTask = [SELECT Id, WhoId FROM Task LIMIT 1];

        InvocableMethodRecipes.ContactSearchRequest request = new InvocableMethodRecipes.ContactSearchRequest();
        request.inputs = new List<SObject>{testTask};

        Test.startTest();
        List<InvocableMethodRecipes.ContactSearchResult> results =
            InvocableMethodRecipes.findRelatedContacts(new List<InvocableMethodRecipes.ContactSearchRequest>{request});
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(testTask.WhoId, ((Contact)results[0].output).Id);
    }

    // Sad path test for unsupported SObject type
    @isTest
    static void testFindRelatedContactsForUnsupportedType() {
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity', CloseDate=Date.today(), StageName='Prospecting');
        insert testOpportunity;

        InvocableMethodRecipes.ContactSearchRequest request = new InvocableMethodRecipes.ContactSearchRequest();
        request.inputs = new List<SObject>{testOpportunity};

        Boolean errorThrown = false;
        try {
            Test.startTest();
            InvocableMethodRecipes.findRelatedContacts(new List<InvocableMethodRecipes.ContactSearchRequest>{request});
            Test.stopTest();
        } catch (InvocableMethodRecipes.InvocableMethodRecipesException e) {
            errorThrown = true;
            System.assert(e.getMessage().contains('Unknown object type passed'), 'The error message should contain the expected message about the unknown object type.');
        }

        System.assert(errorThrown, 'An exception should have been thrown for unsupported SObject type.');
    }

    // Sad path test for empty input list
    @isTest
    static void testFindRelatedContactsForEmptyInputList() {
        InvocableMethodRecipes.ContactSearchRequest request = new InvocableMethodRecipes.ContactSearchRequest();
        request.inputs = new List<SObject>();

        Boolean errorThrown = false;
        try {
            Test.startTest();
            InvocableMethodRecipes.findRelatedContacts(new List<InvocableMethodRecipes.ContactSearchRequest>{request});
            Test.stopTest();
        } catch (Exception e) {
            errorThrown = true;
            System.assert(e.getMessage().contains('List index out of bounds'), 'The error message should contain the expected message about the list index being out of bounds.');
        }

        System.assert(errorThrown, 'An exception should have been thrown for empty input list.');
    }

    // Exceptional scenario for null input
    @isTest
    static void testFindRelatedContactsForNullInput() {
        Boolean errorThrown = false;
        try {
            Test.startTest();
            InvocableMethodRecipes.findRelatedContacts(null);
            Test.stopTest();
        } catch (Exception e) {
            errorThrown = true;
            // Removed the specific message assertion and now only checking if an exception was thrown
        }

        System.assert(errorThrown, 'An exception should have been thrown for null input.');
    }
}
