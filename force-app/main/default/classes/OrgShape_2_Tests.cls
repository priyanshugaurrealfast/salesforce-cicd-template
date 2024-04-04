
@isTest
private class OrgShape_2_Tests {
    
    // Test scenario where seeAllData is set to true
    @isTest(seeAllData=true)
    static void testIsSeeAllDataTrue_WithSeeAllData() {
        Boolean result = new OrgShape().isSeeAllDataTrue();
        System.assertEquals(true, result, 'The method should return true when seeAllData is set to true.');
    }
    
    // Test scenario where seeAllData is not set
    @isTest
    static void testIsSeeAllDataTrue_WithoutSeeAllData() {
        Boolean result = new OrgShape().isSeeAllDataTrue();
        System.assertEquals(false, result, 'The method should return false when seeAllData is not set.');
    }
}
