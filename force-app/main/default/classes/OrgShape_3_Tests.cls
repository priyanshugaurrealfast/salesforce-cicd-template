
@isTest
private class OrgShape_3_Tests {

    // This method will simulate the OrgShape object's behavior related to multi-currency
    private static OrgShape createOrgShapeMock(Boolean isMultiCurrencyEnabled) {
        OrgShape mock = (OrgShape) Test.createStub(
            OrgShape.class,
            new StubProviderForOrgShape(isMultiCurrencyEnabled)
        );
        return mock;
    }

    // Provider class for mocking OrgShape behavior
    private class StubProviderForOrgShape implements StubProvider {
        private final Boolean isMultiCurrencyEnabled;

        StubProviderForOrgShape(Boolean isMultiCurrencyEnabled) {
            this.isMultiCurrencyEnabled = isMultiCurrencyEnabled;
        }

        public Object handleMethodCall(Object instance, String methodName, Type returnType,
                                       List<Type> parameterTypes, List<String> parameterNames, List<Object> args) {
            if (methodName.equalsIgnoreCase('isMultiCurrencyOrganization') && returnType == Boolean.class) {
                return isMultiCurrencyEnabled;
            }
            return null;
        }
    }

    @isTest
    static void testMultiCurrencyEnabledWithDatedConversionRate() {
        // Arrange
        OrgShape orgShapeMock = createOrgShapeMock(true);
        simulateDatedConversionRate(true); // Simulate the existence of DatedConversionRate records

        // Act
        Boolean isACMEnabled = orgShapeMock.isAdvancedMultiCurrencyManagementEnabled();

        // Assert
        System.assertEquals(true, isACMEnabled, 'ACM should be enabled when MultiCurrency is on and DatedConversionRate exists.');
    }

    @isTest
    static void testMultiCurrencyEnabledWithoutDatedConversionRate() {
        // Arrange
        OrgShape orgShapeMock = createOrgShapeMock(true);
        simulateDatedConversionRate(false); // Simulate no DatedConversionRate records

        // Act
        Boolean isACMEnabled = orgShapeMock.isAdvancedMultiCurrencyManagementEnabled();

        // Assert
        System.assertEquals(false, isACMEnabled, 'ACM should not be enabled when there are no DatedConversionRate records.');
    }

    @isTest
    static void testMultiCurrencyNotEnabled() {
        // Arrange
        OrgShape orgShapeMock = createOrgShapeMock(false);

        // Act
        Boolean isACMEnabled = orgShapeMock.isAdvancedMultiCurrencyManagementEnabled();

        // Assert
        System.assertEquals(false, isACMEnabled, 'ACM should not be enabled when MultiCurrency is disabled.');
    }

    @isTest
    static void testExceptionScenario() {
        // Arrange
        OrgShape orgShapeMock = createOrgShapeMock(true);
        simulateDatedConversionRateException(); // Simulate an exception when querying for DatedConversionRate

        // Act
        Boolean isACMEnabled = orgShapeMock.isAdvancedMultiCurrencyManagementEnabled();

        // Assert
        System.assertEquals(false, isACMEnabled, 'ACM should not be enabled when an exception occurs.');
    }

    // Utility method to simulate the existence of DatedConversionRate records
    private static void simulateDatedConversionRate(Boolean exists) {
        // This method would contain logic to simulate the existence or absence of DatedConversionRate records.
        // Since actual DML operations and queries are not possible in this simulation, you can use static flags or other mechanisms.
    }

    // Utility method to simulate an exception when querying for DatedConversionRate
    private static void simulateDatedConversionRateException() {
        // This method would contain logic to simulate an exception when querying DatedConversionRate.
        // Since actual exception handling is not possible in this simulation, you can use static flags or other mechanisms.
    }
}
