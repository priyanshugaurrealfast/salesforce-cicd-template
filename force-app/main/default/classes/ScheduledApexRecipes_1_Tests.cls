
@isTest
private class ScheduledApexRecipes_1_Tests {

    // There's no need for @testSetup since the `execute` method doesn't interact with database records.

    // Utility method to schedule the job and returns the job ID
    private static Id scheduleJob() {
        String jobId = System.schedule('Test Job', ScheduledApexRecipes.TEST_CRON_STATEMENT, new ScheduledApexRecipes());
        return jobId;
    }

    @isTest
    static void testExecute_Successful() {
        // Arrange
        // Bypass the triggers as per the project instructions.
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act
        Test.startTest();
        Id jobId = scheduleJob(); // Schedules the job which in turn calls 'execute'
        Test.stopTest();

        // Assert
        // We assert that a CronTrigger record was created, indicating our job was scheduled.
        CronTrigger job = [SELECT Id, CronExpression, TimesTriggered FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(ScheduledApexRecipes.TEST_CRON_STATEMENT, job.CronExpression, 'The job should be scheduled with the correct CRON expression.');
        System.assertEquals(0, job.TimesTriggered, 'The job should not have triggered yet.');
    }
    
    // Note: Additional test methods could be added if the 'ScheduledApexDemo.runAtMidnight' method
    // resulted in changes that could be observed and asserted upon (such as changes to database records).
}
