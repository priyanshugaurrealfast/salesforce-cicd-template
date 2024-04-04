
@isTest
private class SObjectStringFieldComparator_1_Tests {

    @isTest
    static void testCompareEqualSObjects() {
        SObjectStringFieldComparator comparator = new SObjectStringFieldComparator('Name');
        SObject so1 = new Account(Name = 'Test Account');
        SObject so2 = new Account(Name = 'Test Account');

        Integer result = comparator.compare(so1, so2);
        System.assertEquals(0, result, 'The comparison of identical values should return 0');
    }

    @isTest
    static void testCompareGreaterSObject() {
        SObjectStringFieldComparator comparator = new SObjectStringFieldComparator('Name');
        SObject so1 = new Account(Name = 'B');
        SObject so2 = new Account(Name = 'A');

        Integer result = comparator.compare(so1, so2);
        System.assertEquals(1, result, 'The comparison should favor the first SObject as greater');
    }

    @isTest
    static void testCompareLesserSObject() {
        SObjectStringFieldComparator comparator = new SObjectStringFieldComparator('Name');
        SObject so1 = new Account(Name = 'A');
        SObject so2 = new Account(Name = 'B');

        Integer result = comparator.compare(so1, so2);
        System.assertEquals(-1, result, 'The comparison should favor the second SObject as lesser');
    }

    @isTest
    static void testCompareWithNullValues() {
        SObjectStringFieldComparator comparator = new SObjectStringFieldComparator('Name');
        SObject so1 = new Account(Name = null);
        SObject so2 = new Account(Name = 'Test');

        Integer result = comparator.compare(so1, so2);
        System.assertEquals(-1, result, 'Null should be considered less than any String value');

        result = comparator.compare(so2, so1);
        System.assertEquals(1, result, 'Any String value should be considered greater than null');
    }

    @isTest
    static void testCompareNonSObjectInstances() {
        SObjectStringFieldComparator comparator = new SObjectStringFieldComparator('Name');
        // Assign nulls to objects to simulate the invalid input scenario
        Object o1 = null;
        Object o2 = null;

        Boolean exceptionThrown = false;
        try {
            comparator.compare(o1, o2);
        } catch (ListUtils.CompareException e) {
            exceptionThrown = true;
        } catch (Exception e) {
            exceptionThrown = true; // Catching generic exception as a fallback
        }

        System.assert(exceptionThrown, 'An exception should be thrown when non-SObject instances are compared');
    }
}
