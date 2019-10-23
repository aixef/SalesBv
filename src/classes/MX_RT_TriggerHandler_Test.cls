/**
 *Test de la clase MX_RT_TriggerHandler
 *
 */
@isTest
private class MX_RT_TriggerHandler_Test {

  /**Constante test handler should be bypassed message*/
  private static final String TEST_HANDLER_BYPASS = 'test handler should be bypassed';
  /**Constante TestHandler message*/
  private static final String TEST_HANDLER = 'TestHandler';
  /**Constante afterUpdate message*/
  private static final String AFTER_UPDATE = 'afterUpdate';
  /**Constante trigger error*/
  private static final String TRIG_ERROR = 'Trigger handler called outside of Trigger execution';
  /**Variable last method called*/
  private static String lastMethodCalled;
  /**Variable MX_RT_TriggerHandler_test*/
  private static MX_RT_TriggerHandler_Test.TestHandler handler;

  static {
    handler = new MX_RT_TriggerHandler_Test.TestHandler();
    // override its internal trigger detection
    handler.isTriggerExecuting = true;
  }

  /***************************************
   * unit tests
   ***************************************/

  // contexts tests

  @isTest
  static void testBeforeInsert() {
    beforeInsertMode();
    handler.run();
    System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
  }

  @isTest
  static void testBeforeUpdate() {
    beforeUpdateMode();
    handler.run();
    System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
  }

  @isTest
  static void testBeforeDelete() {
    beforeDeleteMode();
    handler.run();
    System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
  }

  @isTest
  static void testAfterInsert() {
    afterInsertMode();
    handler.run();
    System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
  }

  @isTest
  static void testAfterUpdate() {
    afterUpdateMode();
    handler.run();
    System.assertEquals(AFTER_UPDATE, lastMethodCalled, 'last method should be afterUpdate');
  }

  @isTest
  static void testAfterDelete() {
    afterDeleteMode();
    handler.run();
    System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
  }

  @isTest
  static void testAfterUndelete() {
    afterUndeleteMode();
    handler.run();
    System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
  }

  @isTest
  static void testNonTriggerContext() {
    try {
      handler.run();
      System.assert(false, 'the handler ran but should have thrown');
    } catch(MX_RT_TriggerHandler.TriggerHandlerException te) {
      System.assertEquals(TRIG_ERROR, te.getMessage(), 'the exception message should match');
    } catch(Exception e) {
      System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
    }
  }

  // test bypass api

  @isTest
  static void testBypassAPI() {
    afterUpdateMode();

    // test a bypass and run handler
    MX_RT_TriggerHandler.bypass(TEST_HANDLER);
    handler.run();
    System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    //System.assertEquals(true, MX_RT_TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();

    // clear that bypass and run handler
    MX_RT_TriggerHandler.clearBypass(TEST_HANDLER);
    handler.run();
    System.assertEquals(AFTER_UPDATE, lastMethodCalled, 'last method called should be afterUpdate');
    System.assertEquals(false, MX_RT_TriggerHandler.isBypassed(TEST_HANDLER), TEST_HANDLER_BYPASS);
    resetTest();

    // test a re-bypass and run handler
    MX_RT_TriggerHandler.bypass(TEST_HANDLER);
    handler.run();
    System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    System.assertEquals(true, MX_RT_TriggerHandler.isBypassed(TEST_HANDLER), TEST_HANDLER_BYPASS);
    resetTest();

    // clear all bypasses and run handler
    MX_RT_TriggerHandler.clearAllBypasses();
    handler.run();
    System.assertEquals(AFTER_UPDATE, lastMethodCalled, 'last method called should be afterUpdate');
    System.assertEquals(false, MX_RT_TriggerHandler.isBypassed(TEST_HANDLER), TEST_HANDLER_BYPASS);
    resetTest();
  }

  // instance method tests

  @isTest
  static void testLoopCount() {
    beforeInsertMode();

    // set the max loops to 2
    handler.setMaxLoopCount(2);

    // run the handler twice
    handler.run();
    handler.run();

    // clear the tests
    resetTest();

    try {
      // try running it. This should exceed the limit.
      handler.run();
      System.assert(false, 'the handler should throw on the 3rd run when maxloopcount is 3');
    } catch(MX_RT_TriggerHandler.TriggerHandlerException te) {
      // we're expecting to get here
      System.assertEquals(null, lastMethodCalled, 'last method should be null');
    } catch(Exception e) {
      System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
    }

    // clear the tests
    resetTest();

    // now clear the loop count
    handler.clearMaxLoopCount();

    try {
      // re-run the handler. We shouldn't throw now.
      handler.run();
      System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    } catch(MX_RT_TriggerHandler.TriggerHandlerException te) {
      System.assert(false, 'running the handler after clearing the loop count should not throw');
    } catch(Exception e) {
      System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
    }
  }

  @isTest
  static void testLoopCountClass() {
    final MX_RT_TriggerHandlerLoopCount loopCount = new MX_RT_TriggerHandlerLoopCount();
    System.assertEquals(5, loopCount.getMax(), 'max should be five on init');
    System.assertEquals(0, loopCount.getCount(), 'count should be zero on init');

    loopCount.increment();
    System.assertEquals(1, loopCount.getCount(), 'count should be 1');
    System.assertEquals(false, loopCount.exceeded(), 'should not be exceeded with count of 1');

    loopCount.increment();
    loopCount.increment();
    loopCount.increment();
    loopCount.increment();
    System.assertEquals(5, loopCount.getCount(), 'count should be 5');
    System.assertEquals(false, loopCount.exceeded(), 'should not be exceeded with count of 5');

    loopCount.increment();
    System.assertEquals(6, loopCount.getCount(), 'count should be 6');
    System.assertEquals(true, loopCount.exceeded(), 'should not be exceeded with count of 6');
  }

  // private method tests

  @isTest
  static void testGetHandlerName() {
    System.assertEquals(TEST_HANDLER, handler.getHandlerName(), 'handler name should match class name');
  }

  // test virtual methods

  @isTest
  static void testVirtualMethods() {
    final MX_RT_TriggerHandler tHandler = new MX_RT_TriggerHandler();
    tHandler.beforeInsert();
    tHandler.beforeUpdate();
    tHandler.beforeDelete();
    tHandler.afterInsert();
    tHandler.afterUpdate();
    tHandler.afterDelete();
    tHandler.afterUndelete();
    System.assertEquals(false, tHandler.isTriggerExecuting);
    System.assertEquals(null, tHandler.context);
  }

  /***************************************
   * testing utilities
   ***************************************/

  private static void resetTest() {
    lastMethodCalled = null;
  }

  // modes for testing

  private static void beforeInsertMode() {
    handler.setContextClass.setTriggerContext('before insert', true);
  }

  private static void beforeUpdateMode() {
    handler.setContextClass.setTriggerContext('before update', true);
  }

  private static void beforeDeleteMode() {
    handler.setContextClass.setTriggerContext('before delete', true);
  }

  private static void afterInsertMode() {
    handler.setContextClass.setTriggerContext('after insert', true);
  }

  private static void afterUpdateMode() {
    handler.setContextClass.setTriggerContext('after update', true);
  }

  private static void afterDeleteMode() {
    handler.setContextClass.setTriggerContext('after delete', true);
  }

  private static void afterUndeleteMode() {
    handler.setContextClass.setTriggerContext('after undelete', true);
  }

  /**
  *
  *test implementation of the TriggerHandler
  */

  private class TestHandler extends MX_RT_TriggerHandler {
	/**
    * Llama lastMethodCalled.
    *
    * @param beforeInsert
    * @return
    */
    public override void beforeInsert() {
      MX_RT_TriggerHandler_Test.lastMethodCalled = 'beforeInsert';
    }

	/**
    * Llama lastMethodCalled.
    *
    * @param beforeUpdate
    * @return
    */
    public override void  beforeUpdate() {
      MX_RT_TriggerHandler_Test.lastMethodCalled = 'beforeUpdate';
    }

    /**
    * Llama lastMethodCalled.
    *
    * @param beforeDelete
    * @return
    */
    public override void beforeDelete() {
      MX_RT_TriggerHandler_Test.lastMethodCalled = 'beforeDelete';
    }

    /**
    * Llama lastMethodCalled.
    *
    * @param afterInsert
    * @return
    */
    public override void afterInsert() {
      MX_RT_TriggerHandler_Test.lastMethodCalled = 'afterInsert';
    }

    /**
    * Llama lastMethodCalled.
    *
    * @param afterUpdate
    * @return
    */
    public override void afterUpdate() {
      MX_RT_TriggerHandler_Test.lastMethodCalled = AFTER_UPDATE;
    }

    /**
    * Llama lastMethodCalled.
    *
    * @param afterDelete
    * @return
    */
    public override void afterDelete() {
      MX_RT_TriggerHandler_Test.lastMethodCalled = 'afterDelete';
    }

    /**
    * Llama lastMethodCalled.
    *
    * @param afterUndelete
    * @return
    */
    public override void afterUndelete() {
      MX_RT_TriggerHandler_Test.lastMethodCalled = 'afterUndelete';
    }

  }

}