/**
* 
*clase MX_RT_TriggerHandlerByPass
*/
public virtual class MX_RT_TriggerHandlerByPass {
    /**
    * 
    *@ 
    */
    public static Set<String> bypassedHandlers;
    
    static {
        bypassedHandlers = new Set<String>();
    }
    
    /***************************************
    * public static methods
    ***************************************/
    
    public static void bypass(String handlerName) {
        MX_RT_TriggerHandlerByPass.bypassedHandlers.add(handlerName);
    }
/**
* 
* @
*/    
    public static void clearBypass(String handlerName) {
        MX_RT_TriggerHandlerByPass.bypassedHandlers.remove(handlerName);
    }
/**
* 
*@ 
*/    
    public static Boolean isBypassed(String handlerName) {
        return MX_RT_TriggerHandlerByPass.bypassedHandlers.contains(handlerName);
    }
/**
* 
*@ 
*/    
    public static void clearAllBypasses() {
        MX_RT_TriggerHandlerByPass.bypassedHandlers.clear();
    }
}