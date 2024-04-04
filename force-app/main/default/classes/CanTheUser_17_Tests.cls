
@isTest
private class CanTheUser_17_Tests {

    @testSetup
    static void setup() {
        // Create test data for the Account object since the `destroy` method will be validated using Account records.
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }

    @isTest
    static void testDestroyWithDeletePermissions() {
        // Arrange
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act
        Boolean canDelete = CanTheUser.destroy(accounts);

        // Assert
        System.assert(canDelete, 'The user should have delete permissions.');
    }

    @isTest
    static void testDestroyWithoutDeletePermissions() {
        // Arrange
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        // Simulate the scenario in which the user does not have delete permission.
        System.runAs(new User(Id=UserInfo.getUserId())) {
            // Act
            Boolean canDelete = CanTheUser.destroy(accounts);

            // Assert
            System.assert(!canDelete, 'The user should not have delete permissions.');
        }
    }

    @isTest
    static void testDestroyWithNullList() {
        // Arrange
        List<Account> accounts = null;
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act
        Boolean canDelete = CanTheUser.destroy(accounts);

        // Assert
        System.assert(!canDelete, 'The method should handle null input gracefully.');
    }

    @isTest
    static void testDestroyWithEmptyList() {
        // Arrange
        List<Account> accounts = new List<Account>();
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Act
        Boolean canDelete = CanTheUser.destroy(accounts);

        // Assert
        System.assert(!canDelete, 'The method should handle empty lists gracefully.');
    }
}
