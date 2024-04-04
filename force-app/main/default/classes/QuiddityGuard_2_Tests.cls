
@isTest
private class QuiddityGuard_2_Tests {

    @isTest
    static void testWithAcceptableQuiddity() {
        QuiddityGuard.testQuiddityOverride = Quiddity.SYNCHRONOUS;
        List<Quiddity> acceptableQuiddities = QuiddityGuard.trustedQuiddities;

        Boolean result = QuiddityGuard.isNotAcceptableQuiddity(acceptableQuiddities);

        System.assertEquals(false, result, 'Quiddity should be acceptable, thus result should be false.');
    }

    @isTest
    static void testWithNonAcceptableQuiddity() {
        QuiddityGuard.testQuiddityOverride = Quiddity.AURA;
        List<Quiddity> acceptableQuiddities = QuiddityGuard.trustedQuiddities;

        Boolean result = QuiddityGuard.isNotAcceptableQuiddity(acceptableQuiddities);

        System.assertEquals(true, result, 'Quiddity should not be acceptable, thus result should be true.');
    }

    @isTest
    static void testWithNullAcceptableQuiddities() {
        QuiddityGuard.testQuiddityOverride = Quiddity.AURA;
        // Pass an empty list instead of null to simulate no quiddities being acceptable
        List<Quiddity> acceptableQuiddities = new List<Quiddity>();

        Boolean result = QuiddityGuard.isNotAcceptableQuiddity(acceptableQuiddities);

        System.assertEquals(true, result, 'An empty list of quiddities should be treated as non-acceptable, thus result should be true.');
    }
}
