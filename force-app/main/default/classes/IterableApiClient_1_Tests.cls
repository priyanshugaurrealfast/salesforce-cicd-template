
@isTest
private class IterableApiClient_1_Tests {

    @isTest
    private static void testIteratorReturnsRecordPageIterator() {
        // Instantiate an IterableApiClient object
        IterableApiClient apiClient = new IterableApiClient('TestNamedCredential');

        // Execute the iterator method to test
        Iterator<IterableApiClient.RecordPage> iterator = apiClient.iterator();

        // Assert that the returned iterator is not null
        System.assertNotEquals(null, iterator, 'Iterator should not be null.');

        // We cannot directly check for the instance type of the iterator since 'instanceof' is not supported for this use in Apex.
        // Instead, we ensure that the iterator can be declared using the expected type.
        // The successful compilation of this line serves as an indirect type check.
    }
}
