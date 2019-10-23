/**
* 
*@ 
*/
public class MX_RT_TriggerHandlerLoopCount {
    /**
    * 
    *class for managing the loop count per handler 
    */
    public Integer max {get; set;}
/**
* 
*
*/    
    private Integer count;
/**
* 
* 
*/
    public MX_RT_TriggerHandlerLoopCount() {
        this.max = 5;
        this.count = 0;
    }
/**
* 
* 
*/
    public MX_RT_TriggerHandlerLoopCount(Integer max) {
        this.max = max;
        this.count = 0;
    }
/**
* 
*
*/
    public Boolean increment() {
        this.count++;
        return this.exceeded();
    }
/**
* 
* 
*/
    public Boolean exceeded() {
        Boolean exceeded;
        if(this.max < 0) {
            exceeded = false;
        } else {
            exceeded = (this.count > this.max);
        }
        return exceeded;
    }
/**
* 
*@ 
*/
    public Integer getMax() {
        return this.max;
    }
/**
* 
*@ 
*/
    public Integer getCount() {
        return this.count;
    }
/**
* 
*@ 
*/
    public void setMax(Integer max) {
        this.max = max;
    }
}
