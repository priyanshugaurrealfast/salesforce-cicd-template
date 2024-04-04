
@isTest
private class RecipeTreeViewController_1_Tests {

    @isTest
    static void testCompareToWithDifferentNames() {
        RecipeTreeViewController.RecipeTreeData data1 = new RecipeTreeViewController.RecipeTreeData();
        data1.name = 'ApplePie';
        RecipeTreeViewController.RecipeTreeData data2 = new RecipeTreeViewController.RecipeTreeData();
        data2.name = 'BananaBread';

        // ApplePie should come before BananaBread
        Integer result = data1.compareTo(data2);
        System.assertEquals(-1, result, 'The result should indicate that the first name is less than the second name.');
    }
    
    @isTest
    static void testCompareToWithEqualNames() {
        RecipeTreeViewController.RecipeTreeData data1 = new RecipeTreeViewController.RecipeTreeData();
        data1.name = 'ApplePie';
        RecipeTreeViewController.RecipeTreeData data2 = new RecipeTreeViewController.RecipeTreeData();
        data2.name = 'ApplePie'; // Same name as data1

        // ApplePie compared with ApplePie should be equal
        Integer result = data1.compareTo(data2);
        System.assertEquals(0, result, 'The result should indicate that both names are equal.');
    }
    
    @isTest
    static void testCompareToWithNonRecipeTreeDataInstance() {
        RecipeTreeViewController.RecipeTreeData data = new RecipeTreeViewController.RecipeTreeData();
        data.name = 'CherryCobbler';
        Boolean isExceptionThrown = false;
        
        try {
            // Attempt to compare RecipeTreeData with a String literal, which is an incorrect type
            data.compareTo('IncorrectType');
        } catch (Exception e) {
            isExceptionThrown = true;
        }
        
        System.assert(isExceptionThrown, 'An exception should have been thrown when comparing with a non-RecipeTreeData instance.');
    }
}
