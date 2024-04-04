
@isTest
public class MetadataCatalogRecipes_1_Tests {

    @testSetup
    static void setup() {
        // As FieldDefinition is not a directly insertable object, we are not creating test data here.
    }

    // Happy Path Scenario
    @isTest
    static void testLookupRelationshipDefinition_HappyPath() {
        // Mock a FieldDefinition record
        String fieldDefJson = '{"EntityDefinition": {"DeveloperName": "Contact"}, "DeveloperName": "MyContactField", "RelationshipName": "MyRelationship", "DataType": "Lookup"}';
        FieldDefinition mockFieldDef = (FieldDefinition)JSON.deserialize(fieldDefJson, FieldDefinition.class);

        // Instantiate LookupRelationshipDefinition with the mockFieldDef
        MetadataCatalogRecipes.LookupRelationshipDefinition lrd = new MetadataCatalogRecipes.LookupRelationshipDefinition(mockFieldDef);

        // Assertions
        System.assertEquals('Contact', lrd.looksUpTo, 'The looksUpTo property did not match the expected value.');
        System.assertEquals('MyContactField', lrd.developerName, 'The developerName property did not match the expected value.');
        System.assertEquals('MyRelationship', lrd.relationshipName, 'The relationshipName property did not match the expected value.');
        System.assertEquals('Lookup', lrd.dataType, 'The dataType property did not match the expected value.');
    }

    // Sad Path Scenario
    @isTest
    static void testLookupRelationshipDefinition_SadPath() {
        // Mock a FieldDefinition record with null values.
        String fieldDefJson = '{"EntityDefinition": {}, "DeveloperName": null, "RelationshipName": null, "DataType": null}';
        FieldDefinition mockFieldDef = (FieldDefinition)JSON.deserialize(fieldDefJson, FieldDefinition.class);

        // Instantiate LookupRelationshipDefinition with the mockFieldDef
        MetadataCatalogRecipes.LookupRelationshipDefinition lrd = new MetadataCatalogRecipes.LookupRelationshipDefinition(mockFieldDef);

        // Assertions - when the fields are null, we expect the LookupRelationshipDefinition properties to be null or empty strings.
        System.assertEquals('', lrd.looksUpTo, 'The looksUpTo property should be an empty string when EntityDefinition.DeveloperName is null.');
        System.assertEquals(null, lrd.developerName, 'The developerName property should be null when DeveloperName is null.');
        System.assertEquals(null, lrd.relationshipName, 'The relationshipName property should be null when RelationshipName is null.');
        System.assertEquals(null, lrd.dataType, 'The dataType property should be null when DataType is null.');
    }
}
