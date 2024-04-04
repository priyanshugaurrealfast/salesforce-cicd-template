
@isTest
private class LogTriggerHandler_1_Tests {

    @testSetup
    static void setupTestData() {
        List<Log__e> logRecords = new List<Log__e>();
        // Create test data for Log__e
        for(Integer i = 0; i < 5; i++){
            logRecords.add(new Log__e(
                Log_Message__c='Test Log Message ' + i,
                Quiddity__c='API',
                Request_Id__c=String.valueOf(i),
                Severity__c='ERROR'
            ));
        }
        // Insert test data for Log__e
        insert logRecords;
    }

    @isTest
    static void testAfterInsertHappyPath() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Query for LogEvent__c records after test setup data was inserted.
        List<LogEvent__c> logEvents = [SELECT Log_Data__c, Quiddity__c, Request_Id__c, Severity__c FROM LogEvent__c];
        
        // Assertions
        System.assertEquals(5, logEvents.size(), 'There should be 5 LogEvent__c records created.');
        for(LogEvent__c logEvent : logEvents) {
            System.assertEquals('ERROR', logEvent.Severity__c, 'The severity level should match.');
        }
    }

    @isTest
    static void testAfterInsertSadPath() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create a bad Log__e record that will cause insert to fail
        Log__e badLog = new Log__e(Log_Message__c=null, Quiddity__c='API', Request_Id__c='Bad', Severity__c='ERROR');
        insert badLog;

        Test.startTest();
        new LogTriggerHandler().afterInsert();
        Test.stopTest();

        // Query for LogEvent__c records after insert
        List<LogEvent__c> logEvents = [SELECT Log_Data__c, Quiddity__c, Request_Id__c, Severity__c FROM LogEvent__c];

        // Assertions
        System.assertNotEquals(1, logEvents.size(), 'No LogEvent__c record should be created for bad log.');
        System.assertEquals(0, logEvents.size(), 'Failed inserts should not create any LogEvent__c records.');
    }
}
