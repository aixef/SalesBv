/*
*Desarrollado por:
*Autor:
*Proyecto:               BPyP
*Descripción:
*Cambios (Versiones)
********************************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
********************************************************************************************************
*1.0    |      			 |    				       |           Creación
*1.1    | 07-01-2019     |    Hugo Carrillo        |  Correcciones de Code Smell identificados por Sonar
*/
({
	doInit : function(c, e, h) {
		h.init(c,e,h);
		h.geturl(c,e,h);
		c.set('v.columns', [{
			label: 'CLIENTE',
			fieldName: 'Name',
			type: 'text'
		},
		{
			label: 'EDAD',
			fieldName: 'MX_Age__pc',
			type: 'number'},
			{
				label: 'CUMPLEAÑOS',
				fieldName: 'MX_NextBirthday__pc',
				type: 'date'
			}
		]);
	},
	full : function(c, e, h) {
		h.setoffset(c,e,h,'0');
		c.set('v.isFull', !c.get('v.isFull'));
		h.init(c,e,h);
		c.set('v.currPage','0');
		c.set('v.nCurrPage',0);
	},
	updMth : function(c,e,h){
		h.init(c,e,h);
	},
	frst : function(c,e,h){
		h.setoffset(c,e,h,'0');
		h.init(c,e,h);
		c.set('v.currPage','0');
		c.set('v.nCurrPage',0);
	},
	prev : function(c,e,h){
		h.setoffset(c,e,h,(c.get('v.nCurrPage')-1)*c.get('v.nFullSize'));
		h.init(c,e,h);
		c.set('v.currPage',c.get('v.nCurrPage')-1);
		c.set('v.nCurrPage',c.get('v.nCurrPage')-1);
	},
	next : function(c,e,h){
		h.setoffset(c,e,h,(c.get('v.nCurrPage')+1)*c.get('v.nFullSize'));
		h.init(c,e,h);
		c.set('v.currPage',c.get('v.nCurrPage')+1);
		c.set('v.nCurrPage',c.get('v.nCurrPage')+1);
	},
	lst : function(c,e,h){
		h.setoffset(c,e,h,(c.get('v.nTotPage')-1)*c.get('v.nFullSize'));
		h.init(c,e,h);
		c.set('v.nCurrPage',c.get('v.nTotPage')-1);
		c.set('v.currPage',c.get('v.nTotPage')-1);
	},
})
