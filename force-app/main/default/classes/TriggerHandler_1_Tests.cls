
@isTest
private class TriggerHandler_1_Tests {

    private class MockTriggerHandler extends TriggerHandler {
        public Boolean beforeInsertCalled = false;
        protected override void beforeInsert() {
            beforeInsertCalled = true;
        }
    }

    @testSetup
    static void setupTestData() {
        // No test data required for this isolated test
    }

    private static MockTriggerHandler initHandlerWithMockContext(String context) {
        MockTriggerHandler th = new MockTriggerHandler();
        th.setTriggerContext(context, true);
        return th;
    }
    
    @isTest
    static void testRunBeforeInsert() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        MockTriggerHandler th = initHandlerWithMockContext('before insert');
        
        // Act
        Test.startTest();
        th.run();
        Test.stopTest();    
        
        // Assert
        System.assert(th.beforeInsertCalled, 'beforeInsert should have been called');
    }

    @isTest
    static void testRunWithBypassedHandler() {
        // Arrange
        TriggerHandler.bypass('MockTriggerHandler');
        MockTriggerHandler th = initHandlerWithMockContext('before insert');
        
        // Act
        Test.startTest();
        th.run();
        Test.stopTest();
        
        // Assert
        System.assertFalse(th.beforeInsertCalled, 'beforeInsert should not have been called since handler is bypassed');
    }

    @isTest
    static void testRunExceedsMaxLoopCount() {
        // Arrange
        MockTriggerHandler th = initHandlerWithMockContext('before insert');
        th.setMaxLoopCount(1);
        th.run(); // First run, should be successful
        
        // Act
        Boolean didThrow = false;
        try {
            th.run(); // Second run, should throw TriggerHandlerException
        } catch (TriggerHandler.TriggerHandlerException e) {
            didThrow = true;
        }
        
        // Assert
        System.assertTrue(didThrow, 'Expected a TriggerHandlerException to be thrown due to max loop count exceeded');
    }

    @isTest
    static void testRunOutsideOfTrigger() {
        // Arrange
        TriggerHandler th = new TriggerHandler();
        th.setTriggerContext(null, false);
        
        // Act
        Boolean didThrow = false;
        try {
            th.run(); // Should throw TriggerHandlerException
        } catch (TriggerHandler.TriggerHandlerException e) {
            didThrow = true;
        }
        
        // Assert
        System.assertTrue(didThrow, 'Expected a TriggerHandlerException to be thrown when running outside of a trigger context');
    }

    @isTest
    static void testRunWithUnexpectedContext() {
        // Arrange
        MockTriggerHandler th = initHandlerWithMockContext('unexpected context');
        
        // Act
        Boolean didThrow = false;
        try {
            th.run(); // Should throw TriggerHandlerException due to unexpected context
        } catch (TriggerHandler.TriggerHandlerException e) {
            didThrow = true;
        }
        
        // Assert
        System.assertTrue(didThrow, 'Expected a TriggerHandlerException to be thrown for an unexpected trigger context');
    }
}
