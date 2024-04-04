
@isTest
private class QuiddityGuard_1_Tests {

    // As there are no DML operations, we won't need a test setup in this case.
  
    @isTest
    static void testIsAcceptableQuiddityWhenCurrentQuiddityIsTrusted() {
        // Bypass triggers as per project-specific details (best practice)
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set the testQuiddityOverride to a trusted quiddity
        QuiddityGuard.testQuiddityOverride = Quiddity.SYNCHRONOUS;

        // Assert that the method returns true for a trusted quiddity
        Boolean result = QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedQuiddities);
        System.assert(result, 'The quiddity should be acceptable.');
    }

    @isTest
    static void testIsAcceptableQuiddityWhenCurrentQuiddityIsNotTrusted() {
        // Bypass triggers as per project-specific details (best practice)
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set the testQuiddityOverride to an untrusted quiddity
        QuiddityGuard.testQuiddityOverride = Quiddity.AURA;

        // Assert that the method returns false for an untrusted quiddity
        Boolean result = QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedQuiddities);
        System.assert(!result, 'The quiddity should not be acceptable.');
    }

    @isTest
    static void testIsAcceptableQuiddityWithOverrideMatchingAcceptable() {
        // Bypass triggers as per project-specific details (best practice)
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set the testQuiddityOverride to a trusted test quiddity
        QuiddityGuard.testQuiddityOverride = Quiddity.RUNTEST_ASYNC;

        // Assert that the method returns true when the override is a trusted test quiddity
        Boolean result = QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedTestQuiddities);
        System.assert(result, 'The overridden quiddity should be acceptable.');
    }

    @isTest
    static void testIsAcceptableQuiddityWithOverrideNotMatchingAcceptable() {
        // Bypass triggers as per project-specific details (best practice)
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set the testQuiddityOverride to an untrusted quiddity
        QuiddityGuard.testQuiddityOverride = Quiddity.AURA;

        // Assert that the method returns false when the override is an untrusted quiddity
        Boolean result = QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedTestQuiddities);
        System.assert(!result, 'The overridden quiddity should not be acceptable.');
    }
}
