({
	obtPuntos : function(component, event, helper, nomMetodo) {
        var action = component.get("c."+nomMetodo);
        action.setParams({
            "IDRI":component.get("v.RISelect")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.wrpObj", response.getReturnValue());
                var res=response.getReturnValue();
                helper.drawch(component,event,helper,res);
            }
            else if (state === "ERROR"){
            	alert(response.getError());
            	alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
	},
	drawch : function(component, event, helper,res) {
		//Get the context of the canvas element we want to select
        var ctx = component.find("myChartt2").getElement();
        if(window.barChar!=null){
            window.barChar.clear();
            window.barChar.destroy();
        }
        window.barChar = new Chart(ctx, { type: 'horizontalBar', data: {}, options: window.optPie });
        var height=100+(res.lsLabels.toString().split(',').length*30);
        component.set('v.chartHeight',height);
        if(window.barChar!=null){
            window.barChar.clear();
            window.barChar.destroy();
        }
        window.barChar = new Chart(ctx, { type: 'horizontalBar', data: {}, options: window.optPie });
        var labels=[];
        for (var i = res.lsLabels.toString().split(',').length - 1; i >= 0; i--) {
            barChar.config.data.labels.push(res.lsLabels.toString().split(',')[i]);
            labels.push(res.lsLabels.toString().split(',')[i]);
        }
        for (var j = res.lsTyAcc.toString().split(',').length - 1; j >= 0; j--) {
            var datatemp=[];
            var acc=res.lsTyAcc.toString().split(',')[j];
            var accor=res.lsTyAcc.toString().split(',')[j]
            for (var k = 0; k < labels.length; k++) {
                datatemp.push(res.lsData[(labels[k]+accor)]==null ? 0 : res.lsData[(labels[k]+accor)]);
            }
            var newDataset = {label :acc, backgroundColor :res.lscolor.toString().split('),')[j]+')', data: datatemp, }
            barChar.data.datasets.push(newDataset);
        }
        barChar.update();
	}
})
