
@isTest
private class ApexClassUtilities_2_Tests {
    
    @isTest
    static void testGetRelatedClassesWithSeeTag() {
        // Assume 'ExistingClassWithSee' is the name of a class in your org that has a @see annotation.
        ApexClass klassWithSee = [SELECT Name, Body FROM ApexClass WHERE Name = 'ExistingClassWithSee' LIMIT 1];
        String relatedClasses = ApexClassUtilities.getRelatedClassesFromClassBody(klassWithSee);
        
        // Replace 'RelatedClassName' with the actual related class name that should be found in the class body.
        System.assertNotEquals('', relatedClasses, 'The related classes should not be empty');
        System.assert(relatedClasses.contains('RelatedClassName'), 'The related classes should contain "RelatedClassName"');
    }
    
    @isTest
    static void testGetRelatedClassesWithoutSeeTag() {
        // Assume 'ExistingClassWithoutSee' is the name of a class in your org that does not have a @see annotation.
        ApexClass klassWithoutSee = [SELECT Name, Body FROM ApexClass WHERE Name = 'ExistingClassWithoutSee' LIMIT 1];
        String relatedClasses = ApexClassUtilities.getRelatedClassesFromClassBody(klassWithoutSee);
        
        System.assertEquals('', relatedClasses, 'The related classes should be empty');
    }
    
    @isTest
    static void testGetRelatedClassesWithNullBody() {
        // Use a new ApexClass instance with a null Body to simulate this scenario
        ApexClass klassWithNullBody = new ApexClass(Name = 'TestApexClassWithNullBody');
        String relatedClasses = ApexClassUtilities.getRelatedClassesFromClassBody(klassWithNullBody);
        
        System.assertEquals('', relatedClasses, 'The related classes should be empty for a null body');
    }
}
