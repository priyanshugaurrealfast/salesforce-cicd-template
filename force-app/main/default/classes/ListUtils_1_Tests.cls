
@isTest
private class ListUtils_1_Tests {

    // Utility mock comparator class for testing
    private class MockComparator implements ListUtils.Comparator {
        public Integer compare(Object o1, Object o2) {
            Integer i1 = (Integer)o1;
            Integer i2 = (Integer)o2;
            if (i1 < i2) {
                return -1;
            } else if (i1 > i2) {
                return 1;
            } else {
                return 0;
            }
        }
    }

    // Utility mock comparator that always throws an exception
    private class MockExceptionComparator implements ListUtils.Comparator {
        public Integer compare(Object o1, Object o2) {
            throw new ListUtils.CompareException();
        }
    }

    @isTest
    static void testSort_ValidList_SortedCorrectly() {
        List<Object> testList = new List<Object>{5, 3, 4, 1, 2};
        ListUtils.Comparator comparator = new MockComparator();

        Test.startTest();
        ListUtils.sort(testList, comparator);
        Test.stopTest();

        // Assertions
        System.assertEquals(1, (Integer)testList[0], 'First element should be the smallest.');
        System.assertEquals(2, (Integer)testList[1], 'Second element should be the second smallest.');
        System.assertEquals(3, (Integer)testList[2], 'Third element should be the third smallest.');
        System.assertEquals(4, (Integer)testList[3], 'Fourth element should be the fourth smallest.');
        System.assertEquals(5, (Integer)testList[4], 'Last element should be the largest.');
    }

    @isTest
    static void testSort_EmptyList_NoChange() {
        List<Object> testList = new List<Object>{};
        ListUtils.Comparator comparator = new MockComparator();

        Test.startTest();
        ListUtils.sort(testList, comparator);
        Test.stopTest();

        // Assertions
        System.assertEquals(0, testList.size(), 'List should remain empty.');
    }

    @isTest
    static void testSort_CompareException_ThrowsException() {
        List<Object> testList = new List<Object>{5, 3};
        ListUtils.Comparator exceptionComparator = new MockExceptionComparator();
        
        Test.startTest();
        Boolean exceptionCaught = false;
        try {
            ListUtils.sort(testList, exceptionComparator);
        } catch (ListUtils.CompareException e) {
            exceptionCaught = true;
        }
        Test.stopTest();

        // Assertions
        System.assert(exceptionCaught, 'CompareException should have been thrown.');
    }
}
