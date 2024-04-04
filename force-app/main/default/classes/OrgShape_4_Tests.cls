
@isTest
private class OrgShape_4_Tests {
    
    // Use the @testSetup annotation to create test data
    @testSetup
    static void setup() {
        // There is no need to create test data for the Organization object because
        // it always exists by default and can't be manually created or modified.
    }
    
    // Test to ensure the doLoad method returns the Organization record (Happy Path)
    @isTest
    static void testDoLoadMethodReturnsOrgRecord() {
        // Arrange (nothing to arrange as Organization data exists by default)
        
        // Act
        Organization result = new OrgShape.CachedOrgShape().doLoad(null);
        
        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals('Organization', String.valueOf(result.getSObjectType()), 'The result should be an organization record.');
    }
    
    // Since the method doesn't throw any exception, there is no sad path to test here.
    // We assume that the Organization query will always succeed in the context of this method.
}
