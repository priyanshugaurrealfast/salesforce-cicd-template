
@isTest
private class StubExampleConsumer_3_Tests {

    private class StubExampleMock implements StubProvider {
        private String greeting;

        public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
                                       Type returnType, List<Type> parameterTypes, List<String> parameterNames, 
                                       List<Object> args) {
            if (stubbedMethodName == 'setGreeting' && parameterTypes[0] == String.class) {
                this.greeting = (String)args[0];
            }
            if (stubbedMethodName == 'getGreeting' && args.isEmpty()) {
                return this.greeting;
            }
            return null;
        }
    }

    @isTest
    static void testSetGreetingWithValidString() {
        StubExample stub = (StubExample)Test.createStub(StubExample.class, new StubExampleMock());
        StubExampleConsumer consumer = new StubExampleConsumer(stub);
        
        String expectedGreeting = 'Hello, world!';
        consumer.setGreeting(expectedGreeting);
        String actualGreeting = consumer.getGreeting();
        
        System.assertEquals(expectedGreeting, actualGreeting, 'The greeting should be set to the provided string.');
    }
    
    @isTest
    static void testSetGreetingWithNull() {
        StubExample stub = (StubExample)Test.createStub(StubExample.class, new StubExampleMock());
        StubExampleConsumer consumer = new StubExampleConsumer(stub);
        
        consumer.setGreeting((String)null); // Explicitly casting null to String
        String actualGreeting = consumer.getGreeting();
        
        System.assertEquals(null, actualGreeting, 'The greeting should be set to null.');
    }
}
