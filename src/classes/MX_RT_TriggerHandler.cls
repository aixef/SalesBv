/**
* 
*
* @author 
*/
public virtual class MX_RT_TriggerHandler extends MX_RT_TriggerHandlerByPass {
    
/**
*
*static map of handlername, times run() was invoked 
*/    
    private static Map<String, MX_RT_TriggerHandlerLoopCount> loopCountMap;
    
/**
* 
*the current context of the trigger, overridable in tests
*/    
    @TestVisible
    private MX_RT_TriggerHandlerEnum.TriggerContext context;
    
/**
* 
*thh current context event of the trigger, overridable in tests 
*/    
    @TestVisible
    private MX_RT_TriggerHandlerEnum.TriggerEvent contextEvent;
    
/**
* 
*the current context of the trigger, overridable in tests 
*/    
    @TestVisible
    private Boolean isTriggerExecuting;
    
/**
* 
*instance of the MX_RT_TriggerHandlerContext class 
*/    
    @TestVisible
    private MX_RT_TriggerHandlerContext setContextClass;
    
/**
* 
*static initialization 
*/    
    static {
        loopCountMap = new Map<String, MX_RT_TriggerHandlerLoopCount>();
    }
    
/**
* 
*constructor 
*/    
    public MX_RT_TriggerHandler() {
        setContextClass = new MX_RT_TriggerHandlerContext();
        setContextClass.setTriggerContext(); //NOSONAR
        isTriggerExecuting = setContextClass.getisTriggerExecuting();
    }
    
    /***************************************
    * public instance methods
    ***************************************/
    
/**
* 
*main method that will be called during execution 
*/    
    public void run() {
        context = setContextClass.getContext();
        contextEvent = setContextClass.getContextEvent();
        
        if(!validateRun()) {
            return;
        }
        
        addToLoopCount();
        
/**
* 
*dispatch to the correct handler method 
*/        
        if(contextEvent == MX_RT_TriggerHandlerEnum.TriggerEvent.BEFORE) {
            runBeforeHandlers();
        } else if(contextEvent == MX_RT_TriggerHandlerEnum.TriggerEvent.AFTER) {
            runAfterHandlers();
        }
    }
    
    @TestVisible
    private void runBeforeHandlers() {
        if(this.context == MX_RT_TriggerHandlerEnum.TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        } else if(this.context == MX_RT_TriggerHandlerEnum.TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if(this.context == MX_RT_TriggerHandlerEnum.TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        }
    }
    
    @TestVisible
    private void runAfterHandlers() {
        if(this.context == MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        } else if(this.context == MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        } else if(this.context == MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        } else if(this.context == MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }
    }
/**
* 
* @
*/    
    public void setMaxLoopCount(Integer max) {
        final String handlerName = getHandlerName();
        System.debug(handlerName);
        if(MX_RT_TriggerHandler.loopCountMap.containsKey(handlerName)) {
            MX_RT_TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        } else {
            MX_RT_TriggerHandler.loopCountMap.put(handlerName, new MX_RT_TriggerHandlerLoopCount(max));
        }
    }
/**
* 
* @
*/    
    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }
    
    
/**
* 
*increment the loop count 
*/    
    @TestVisible
    private void addToLoopCount() {
        final String handlerName = getHandlerName();
        if(MX_RT_TriggerHandler.loopCountMap.containsKey(handlerName)) {
            final Boolean exceeded = MX_RT_TriggerHandler.loopCountMap.get(handlerName).increment();
            if(exceeded) {
                final Integer max = MX_RT_TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }
    
/**
* 
*make sure this trigger should continue to run 
*/    
    @TestVisible
    private Boolean validateRun() {
        if(!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        return !MX_RT_TriggerHandlerByPass.bypassedHandlers.contains(getHandlerName());
    }
    
    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }
    
    /***************************************
    * context methods
    ***************************************/
        
        // context-specific methods for override
        
        /**
    * --------------------------------------------------------------------------------------
    * @Description Handles the before insert trigger event  
    **/
    @TestVisible
    protected virtual void beforeInsert() {
        
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description Handles the before update trigger event 
    **/
    @TestVisible
    protected virtual void beforeUpdate() {
        
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description Handles the before delete trigger event  
    **/
    @TestVisible
    protected virtual void beforeDelete() {
        
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description Handles the after insert trigger event  
    **/
    @TestVisible
    protected virtual void afterInsert() {
        
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description Handles the after update trigger event  
    **/
    @TestVisible
    protected virtual void afterUpdate() {
        
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description Handles the after delete trigger event  
    **/
    @TestVisible
    protected virtual void afterDelete() {
        
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description Handles the after undelete trigger event  
    **/
    @TestVisible
    protected virtual void afterUndelete() {
        
    }
    
    /***************************************
    * inner classes
    ***************************************/
    
/**
* 
*inner class for managing the loop count per handler 
*@TestVisible
*/    
    
    
    
/**
* 
*exception class 
*/    
    public class TriggerHandlerException extends Exception {}
    
}