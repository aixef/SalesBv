/*
*Desarrollado por:
*Autor:
*Proyecto:
*Descripción:            Componente Helper
*Cambios (Versiones)
*************************************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************************************
*1.0    |                |                          |
*1.1    | 21-05-2019     |  Hugo I. Carrillo Béjar  |   Correcciones de Code Smell identificados por Sonar
*/
({
    graficaConsulta: function (component, evolucion, parametros) {
        var NomInforme2 = component.get("v.NombreInforme");
        if (NomInforme2 != null && NomInforme2 !== '') {
            var ownerUgParam = component.get("v.UgUserg");
            var riOwner = component.get("v.riOwner");
            var indicador = component.get("v.Indicador");
            var action = component.get("c.getGeneraJSONReporte");
            action.setParams({
                "nombreReporte": NomInforme2,
                "ownerUG": ownerUgParam,
                "riOwner": riOwner,
                "indicador": indicador
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.JsonConsultas", response.getReturnValue());
                    var reportResultData = component.get("v.JsonConsultas");
                    if (reportResultData != null) {
                        this.helperGraficaConsulta(component, reportResultData);
                    }
                }
                component.set("v.BanderaEjecucion", true);
            });
            $A.enqueueAction(action);
        }
    },
    helperGraficaConsulta: function (component, reportResultData) {
        var concepto = [];
        var chartData = [];
        var chartData2 = [];
        var chartData3 = [];
        var chartData4 = [];
        var chartData5 = [];
        var nombreColumnas = [];
        var numeroGraficaCentro = parseInt("0");
        for (var i = 0; i < reportResultData.length; i++) {
            if (reportResultData.length > 2) {
                for (var j = 0; j < reportResultData[i].length; j++) {
                    switch (i) {
                        case 0:
                            concepto[j] = reportResultData[i][j];
                            break;
                        case 1:
                            nombreColumnas[j] = reportResultData[i][j];
                            break;
                        case 2:
                            chartData[j] = reportResultData[i][j];
                            numeroGraficaCentro = numeroGraficaCentro + parseInt(chartData[j]);
                            break;
                        case 3:
                            chartData2[j] = reportResultData[i][j];
                            break;
                        case 4:
                            chartData3[j] = reportResultData[i][j];
                            break;
                        case 5:
                            chartData4[j] = reportResultData[i][j];
                            break;
                        case 6:
                            chartData5[j] = reportResultData[i][j];
                            break;
                    }
                }
            }
            component.set("v.conceptoList", concepto);
            component.set("v.ParametrosDina", chartData);
            component.set("v.ParametrosDina2", chartData2);
            component.set("v.ParametrosDina3", chartData3);
            component.set("v.ParametrosDina4", chartData4);
            component.set("v.ParametrosDina5", chartData5);
            component.set("v.labelColumnas", nombreColumnas);
            component.set("v.numeroCentro", numeroGraficaCentro);
        }
    },
    graficaEvolucion: function (component, evolucion) {
        if (component.get("v.NombreInforme") != null && component.get("v.NombreInforme") !== '') {

            var action = component.get("c.getInforme");
            action.setParams({
                "NomInforme": component.get("v.NombreInforme")
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var reportResultData = JSON.parse(response.getReturnValue());
                    var concepto = [];
                    var chartData = [];
                    var chartData2 = [];
                    var chartData3 = [];
                    var chartData4 = [];
                    var chartData5 = [];
                    if (reportResultData.groupingsDown != null && reportResultData.groupingsDown.groupings != null) {
                        this.helperGraficaEvolucion(component, reportResultData);

                    } else {
                        this.helperSetGraficaEvolucion(component, concepto, chartData, chartData2, chartData3, chartData4, chartData5);
                    }
                }
                component.set("v.BanderaEjecucion", true);
            });
            $A.enqueueAction(action);
        }
    },
    helperGraficaEvolucion: function (component, reportResultData) {
        var concepto = [];
        var chartData = [];
        var chartData2 = [];
        var chartData3 = [];
        var chartData4 = [];
        var chartData5 = [];
        var parametros = component.get("v.TipoGrafica");
        for (var i = 0; i < (reportResultData.groupingsDown.groupings.length); i++) {
            if (parametros !== "doughnut") {
                var tempconcepto = reportResultData.groupingsDown.groupings[i].groupings;
                for (var w = 0; w < (tempconcepto.length); w++) {
                    var conceptotemp = tempconcepto[w].label;
                    var keyTemp2 = tempconcepto[w].key;
                    concepto.push(conceptotemp);
                    var valueTemp2 = reportResultData.factMap[keyTemp2 + '!T'].aggregates[0].value;
                    component.set("v.parametrosCirculo", valueTemp2);
                    switch (conceptotemp) {
                        case concepto[0]:
                            chartData[i] = valueTemp2;
                            break;
                        case concepto[1]:
                            chartData2[i] = valueTemp2;
                            break;
                        case concepto[2]:
                            chartData3[i] = valueTemp2;
                            break;
                        case concepto[3]:
                            chartData4[i] = valueTemp2;
                            break;
                        case concepto[4]:
                            chartData5[i] = valueTemp2;
                            break;
                    }
                }
            } else {
                var keyTemp = reportResultData.groupingsDown.groupings[i].key;
                var valueTemp = reportResultData.factMap[keyTemp + '!T'].aggregates[0].value;
                chartData.push(valueTemp);
            }
        }
        this.helperSetGraficaEvolucion(component, concepto, chartData, chartData2, chartData3, chartData4, chartData5);
    },
    helperSetGraficaEvolucion: function (component, concepto, chartData, chartData2, chartData3, chartData4, chartData5) {
        component.set("v.conceptoList", concepto);
        component.set("v.ParametrosDina", chartData);
        component.set("v.ParametrosDina2", chartData2);
        component.set("v.ParametrosDina3", chartData3);
        component.set("v.ParametrosDina4", chartData4);
        component.set("v.ParametrosDina5", chartData5);
    },
    dibujaGrafico: function (component, evolucion) {
        var action = component.get("c.getTamanio");
        var numerotostring = component.get("v.numeroCentro");
        var numeroenv = numerotostring.toString();
        action.setParams({
            numero: numeroenv
        });
        action.setCallback(this, function (response) {
            var tamanio = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log(tamanio);
                component.set("v.tamanoValorCentro", tamanio);
                this.helperConcepto1(component, evolucion);
            }
        });
        $A.enqueueAction(action);
    },
    helperConcepto1: function (component, evolucion) {
        var nombreColumnas = component.get("v.labelColumnas");
        var concepto = component.get("v.conceptoList");
        var bibliotecaColor = component.get("v.Colores");
        var ParametrosDinamicos = component.get("v.ParametrosDina");
        var grafica2 = [];
        var ParametrosDinamicos2 = component.get("v.ParametrosDina2");
        var datasetstemp = {
            label: concepto[0],
            data: ParametrosDinamicos,
            backgroundColor: bibliotecaColor[0],
            borderColor: bibliotecaColor[0],
            borderWidth: 2
        }
        var data = {
            labels: nombreColumnas,
            datasets: [
                datasetstemp,
            ],
        }
        if (concepto[1] != null && concepto[1] !== "") {
            grafica2 = {
                label: concepto[1],
                data: ParametrosDinamicos2,
                backgroundColor: bibliotecaColor[1],
                borderColor: bibliotecaColor[1],
                borderWidth: 2
            }
            data = {
                labels: nombreColumnas,
                datasets: [
                    datasetstemp,
                    grafica2,
                ],
            }
        }
        this.helperConcepto2(component, datasetstemp, grafica2, data, evolucion);

    },
    helperConcepto2: function (component, datasetstemp, grafica2, data, evolucion) {
        var nombreColumnas = component.get("v.labelColumnas");
        var concepto = component.get("v.conceptoList");
        var bibliotecaColor = component.get("v.Colores");
        var grafica3 = [];
        var ParametrosDinamicos3 = component.get("v.ParametrosDina3");
        if (concepto[2] != null && concepto[2] !== "" && concepto[2] !== concepto[0]) {
            grafica3 = {
                label: concepto[2],
                data: ParametrosDinamicos3,
                backgroundColor: bibliotecaColor[2],
                borderColor: bibliotecaColor[2],
                borderWidth: 2
            }
            data = {
                labels: nombreColumnas,
                datasets: [
                    datasetstemp,
                    grafica2,
                    grafica3,
                ],
            }
        }
        this.helperConcepto3(component, datasetstemp, grafica2, grafica3, data, evolucion);

    },
    helperConcepto3: function (component, datasetstemp, grafica2, grafica3, data, evolucion) {
        var nombreColumnas = component.get("v.labelColumnas");
        var concepto = component.get("v.conceptoList");
        var bibliotecaColor = component.get("v.Colores");
        var grafica4 = [];
        var ParametrosDinamicos4 = component.get("v.ParametrosDina4");
        if ((concepto[3] != null && concepto[3] !== "" && concepto[3] !== concepto[0]) && (concepto[3] !== (concepto[2] && concepto[1]))) {
            grafica4 = {
                label: concepto[3],
                data: ParametrosDinamicos4,
                backgroundColor: bibliotecaColor[3],
                borderColor: bibliotecaColor[3],
                borderWidth: 2
            }
            data = {
                labels: nombreColumnas,
                datasets: [
                    datasetstemp,
                    grafica2,
                    grafica3,
                    grafica4,
                ],
            }
        }
        this.helperConcepto4(component, datasetstemp, grafica2, grafica3, grafica4, data, evolucion);

    },
    helperConcepto4: function (component, datasetstemp, grafica2, grafica3, grafica4, data, evolucion) {
        var nombreColumnas = component.get("v.labelColumnas");
        var concepto = component.get("v.conceptoList");
        var bibliotecaColor = component.get("v.Colores");
        var grafica5 = [];
        var ParametrosDinamicos5 = component.get("v.ParametrosDina5");
        if ((concepto[4] != null && concepto[4] !== "" && concepto[4] !== concepto[0]) && (concepto[4] !== (concepto[2] && concepto[1]))) {
            grafica5 = {
                label: concepto[4],
                data: ParametrosDinamicos5,
                backgroundColor: bibliotecaColor[4],
                borderColor: bibliotecaColor[4],
                borderWidth: 2
            }
            data = {
                labels: nombreColumnas,
                datasets: [
                    datasetstemp,
                    grafica2,
                    grafica3,
                    grafica4,
                    grafica5,
                ],
            }
        }
        this.helperDoughnut(component, data, evolucion, concepto, bibliotecaColor);

    },
    helperDoughnut: function (component, data, evolucion, concepto, bibliotecaColor) {

        var posicion = component.get("v.posicionLeyenda");
        var parametros = component.get("v.TipoGrafica");
        var ParametrosDinamicos = component.get("v.ParametrosDina");
        var linea100 = [];
        if (component.get("v.NombreInforme") !== ('Logro_por_indicador')) {
            linea100 = {
                stacked: true,
                gridLines: {
                    display: false
                }
            }
        }
        if (parametros !== "doughnut") {
            data;
            window.myDoughnutChart = new Chart(evolucion, {
                type: parametros,
                data: data,
                legend: {
                    display: false
                },
                options: {
                    legend: {
                        display: true,
                        position: posicion,
                        fullWidth: true,
                        reverse: false,
                        labels: {
                            fontColor: '#032363'
                        },
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: true,
                    },
                    scales: {
                        yAxes: [{
                            stacked: true,
                            ticks: {
                                beginAtZero: true
                            },
                            gridLines: {
                                display: false
                            }
                        }],
                        xAxes: [{
                            stacked: true,
                            linea100
                        }],
                    }
                }
            });
        } else {
            var data2 = {
                labels: concepto,
                datasets: [{
                    label: concepto[0],
                    data: ParametrosDinamicos,
                    backgroundColor: [
                        bibliotecaColor[0],
                        bibliotecaColor[1],
                        bibliotecaColor[2],
                        bibliotecaColor[3]
                    ],
                    borderColor: [
                        bibliotecaColor[0],
                        bibliotecaColor[1],
                        bibliotecaColor[2],
                        bibliotecaColor[3]
                    ],
                    borderWidth: 2
                }],
            };
            this.helperValorTamano(component, data2, parametros, evolucion, posicion);
        }

    },
    helperValorTamano: function (component, data2, parametros, evolucion, posicion) {

        var appTrue = false;
        if (component.get("v.NombreCanvas") === 'Apoyos') {
            appTrue = true;
        }
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            if (appTrue) {
                this.helperSetTamanoTrue(component, appTrue, true, data2, parametros, evolucion, posicion);
            } else {
                this.helperSetTamanoFalse(component, appTrue, true, data2, parametros, evolucion, posicion);
            }
        } else {
            if (appTrue) {
                this.helperSetTamanoTrue(component, false, data2, parametros, evolucion, posicion);
            } else {
                this.helperSetTamanoFalse(component, false, data2, parametros, evolucion, posicion);
            }
        }

    },
    helperSetTamanoTrue: function (component, movil, data2, parametros, evolucion, posicion) {
        var valortamano;
        var aTrue = [50, 51, 52, 53, 54, 55];
        var tamano = component.get("v.tamanoValorCentro");
        if (tamano <= 1) {
            valortamano = aTrue[0];
        } else if ((tamano === 3) && (movil)) {
            valortamano = aTrue[2 - 1];
        } else if ((tamano === 5 || tamano === 6 || tamano === 7) && (!movil)) {
            valortamano = aTrue[5 - 1];
        } else {
            valortamano = aTrue[tamano - 1];
        }
        this.helperWindowDoughnut(component, data2, parametros, evolucion, posicion, valortamano);
    },
    helperSetTamanoFalse: function (component, movil, data2, parametros, evolucion, posicion) {
        var valortamano;
        var aFalse = [63, 64, 65, 66, 67, 68];
        var tamano = component.get("v.tamanoValorCentro");
        if (tamano <= 1) {
            valortamano = aFalse[0];
        } else if ((tamano === 5 || tamano === 6 || tamano === 7) && (!movil)) {
            valortamano = aFalse[5 - 1];
        } else {
            valortamano = aFalse[tamano - 1];
        }
        this.helperWindowDoughnut(component, data2, parametros, evolucion, posicion, valortamano);
    },
    helperWindowDoughnut: function (component, data2, parametros, evolucion, posicion, valortamano) {
        var numeroGraficaCentro2 = component.get("v.numeroCentro");
        window.myDoughnutChart = new Chart(evolucion, {
            type: parametros,
            plugins: [{
                afterDraw: function (myDoughnutChart) {
                    var width = myDoughnutChart.chart.width,
                        height = myDoughnutChart.chart.height,
                        ctx = myDoughnutChart.chart.ctx;

                    var text = numeroGraficaCentro2;
                    var fontSize = (width * 0.5) / ((ctx.measureText(text).width / 2) + valortamano);
                    ctx.restore();
                    ctx.font = fontSize + "em sans-serif";
                    ctx.textBaseline = "middle";
                    var textX = Math.round((width / 2) - ((ctx.measureText(text).width / 2) + valortamano)),
                        textY = height / 2;
                    ctx.fillText(text, textX, textY);
                    ctx.font = 'sans-serif';
                    ctx.save();
                }
            }],
            data: data2,
            options: {
                legend: {
                    responsive: true,
                    display: true,
                    position: posicion,
                    fullWidth: true,
                    reverse: true,
                    labels: {
                        fontColor: '#032363'
                    },
                },
            }
        });
    }
})
