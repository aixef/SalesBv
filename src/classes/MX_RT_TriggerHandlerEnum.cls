/**
* 
*@ 
*/
public class MX_RT_TriggerHandlerEnum {
/**
* 
*possible trigger contexts
*/    
    @TestVisible
    public enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }
    
    @TestVisible
    /**
    * 
    *@ 
    */
    public enum TriggerEvent {
        BEFORE, 
        AFTER
    }
}