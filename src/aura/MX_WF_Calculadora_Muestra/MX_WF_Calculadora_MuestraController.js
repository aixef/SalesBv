({
	calcularMuestra: function(component, event, helper) {
		var confianza = component.find('confianza').get('v.value');
		var pIntervalo = component.find('intervalo').get('v.value') / 100;
		var poblacion = component.find('poblacion').get('v.value');

		var tMuestra = 0;
		if (pIntervalo >= 0.0001 && pIntervalo <= 0.5) {
			if (confianza == '95%') {
				tMuestra =
					poblacion *
					(1.96 * 1.96) *
					(0.5 * 0.5) /
					(pIntervalo * pIntervalo * (poblacion - 1) + 1.96 * 1.96 * (0.5 * 0.5));
			} else {
				tMuestra =
					poblacion *
					(2.58 * 2.58) *
					(0.5 * 0.5) /
					(pIntervalo * pIntervalo * (poblacion - 1) + 2.58 * 2.58 * (0.5 * 0.5));
			}

			console.log(tMuestra);
			tMuestra = Math.round(tMuestra);

			component.set('v.muestra', tMuestra);
		}
	}
});
