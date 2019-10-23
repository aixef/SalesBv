/**
* 
*@ 
*/
public class MX_RT_TriggerHandlerContext {
    
/**
* 
*the current context of the trigger, overridable in tests 
*/    
    @TestVisible
    private MX_RT_TriggerHandlerEnum.TriggerContext context;
    
/**
* 
*teh current context event of the trigger, overridable in tests 
*/    
    @TestVisible
    private MX_RT_TriggerHandlerEnum.TriggerEvent contextEvent;
    
/**
* 
*the current context of the trigger, overridable in tests 
*/    
    @TestVisible
    private Boolean isTriggerExecuting;
    
    /***************************************
    * private instancemethods
    ***************************************/
    
    @TestVisible
    public void setTriggerContext() {
        this.setTriggerContext(null, false);
        
    }
    
    @TestVisible
    private void setTriggerContext(String forcedContext, Boolean testMode) {
        if(Trigger.isExecuting || testMode) {
            this.isTriggerExecuting = true;
        } else {
            this.isTriggerExecuting = false;
            return;
        }
        
        if(forcedContext == null) {
            setStaticContext();
        } else {
            setForcedContext(forcedContext);
        }
    }
    
    @TestVisible
    private void setForcedContext(String forcedContext) {
        if(forcedContext.startsWith('before')) {
            setBeforeForcedContext(forcedContext);
        } else if(forcedContext.startsWith('after')) {
            setAfterForcedContext(forcedContext);
        }
    }
    
    @TestVisible
    private void setBeforeForcedContext(String forcedContext) {
        final String biContext = 'before insert';
        final String buContext = 'before update';
        final String bdContext = 'before delete';
        setBeforeContextEvent();
        if(forcedContext == biContext) {
            setBeforeInsertContext();
        } else if(forcedContext == buContext) {
            setBeforeUpdateContext();
        } else if(forcedContext == bdContext) {
            setBeforeDeleteContext();
        }
    }
    
    @TestVisible
    private void setAfterForcedContext(String forcedContext) {
        final String aiContext = 'after insert';
        final String auContext = 'after update';
        final String adContext = 'after delete';
        final String aundContext = 'after undelete';
        setAfterContextEvent();
        if(forcedContext == aiContext) {
            setAfterInsertContext();
        } else if(forcedContext == auContext) {
            setAfterUpdateContext();
        } else if(forcedContext == adContext) {
            setAfterDeleteContext();
        } else if(forcedContext == aundContext) {
            setAfterUndeleteContext();
        }
    }
    
    @TestVisible
    private void setStaticContext() {
        if(Trigger.isExecuting) {
            if(Trigger.isBefore) {
                setStaticBeforeContext();
            } else if(Trigger.isAfter) {
                setStaticAfterContext();
            }
        }
    }
    
    @TestVisible
    private void setStaticBeforeContext() {
        setBeforeContextEvent();
        if(Trigger.isInsert) {
            setBeforeInsertContext();
        } else if(Trigger.isUpdate) {
            setBeforeUpdateContext();
        } else if(Trigger.isDelete) {
            setBeforeDeleteContext();
        }
    }
    
    @TestVisible
    private void setStaticAfterContext() {
        setAfterContextEvent();
        if(Trigger.isInsert) {
            setAfterInsertContext();
        } else if(Trigger.isUpdate) {
            setAfterUpdateContext();
        } else if(Trigger.isDelete) {
            setAfterDeleteContext();
        } else if(Trigger.isUndelete) {
            setAfterUndeleteContext();
        }
    }
    
    @TestVisible
    private void setBeforeContextEvent() {
        this.contextEvent = MX_RT_TriggerHandlerEnum.TriggerEvent.BEFORE;
    }
    
    @TestVisible
    private void setAfterContextEvent() {
        this.contextEvent = MX_RT_TriggerHandlerEnum.TriggerEvent.AFTER;
    }
    
    @TestVisible
    private void setBeforeInsertContext() {
        this.context = MX_RT_TriggerHandlerEnum.TriggerContext.BEFORE_INSERT;
    }
    
    @TestVisible
    private void setBeforeUpdateContext() {
        this.context = MX_RT_TriggerHandlerEnum.TriggerContext.BEFORE_UPDATE;
    }
    
    @TestVisible
    private void setBeforeDeleteContext() {
        this.context = MX_RT_TriggerHandlerEnum.TriggerContext.BEFORE_DELETE;
    }
    
    @TestVisible
    private void setAfterInsertContext() {
        this.context = MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_INSERT;
    }
    
    @TestVisible
    private void setAfterUpdateContext() {
        this.context = MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_UPDATE;
    }
    
    @TestVisible
    private void setAfterDeleteContext() {
        this.context = MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_DELETE;
    }
    
    @TestVisible
    private void setAfterUndeleteContext() {
        this.context = MX_RT_TriggerHandlerEnum.TriggerContext.AFTER_UNDELETE;
    }
/**
* 
*@ 
*/    
    public MX_RT_TriggerHandlerEnum.TriggerContext getContext() {
        return this.context;
    }
/**
* 
*@ 
*/    
    public MX_RT_TriggerHandlerEnum.TriggerEvent getContextEvent() {
        return this.contextEvent;
    }
/**
* 
*@ 
*/    
    public Boolean getisTriggerExecuting() {
        return this.isTriggerExecuting;
    }
}