({
    generateChart: function (component, event, helper) {
        window.optPie = {
            tooltips: {
                enabled: true, callbacks: {
                    label: function (tooltipItem, data) {
                        return data.datasets[tooltipItem.datasetIndex].label + ': ' + ' ' + tooltipItem.xLabel.toString() + '%';
                    },
                }
            }, hover: {
                animationDuration: 10
            },
            legend: {
                position: 'bottom',
                padding: 10,
                onClick: function (event, legendItem) { },
            }, animation: {
                onComplete: function () {
                    var chartInstance = this.chart;
                    var ctx = chartInstance.ctx;
                    ctx.textAlign = "left";
                    ctx.fillStyle = "#fff";
                    Chart.helpers.each(this.data.datasets.forEach(function (dataset, i) {
                        var meta = chartInstance.controller.getDatasetMeta(i);
                        Chart.helpers.each(meta.data.forEach(function (bar, index) {
                            var data = dataset.data[index];
                            if (data !== 0) {
                                ctx.fillText(data + '%', bar._model.x - 40, bar._model.y - 10);
                            }
                        }), this)
                    }), this);
                }
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                xAxes: [{
                    stacked: true,
                    gridLines: {
                        display: false
                    },
                    ticks: {
                        callback: function (value, index, values) {
                            return value + '%';
                        }
                    }
                }],
                yAxes: [{
                    stacked: true,
                    gridLines: {
                        display: false
                    },
                }]
            },
        };

        window.dataToTableAcc = function (dataset, title) {
            var html = '<table>';
            html += '<thead><tr><th >' + title + '</th>';
            var columnCount = 0;
            jQuery.each(dataset.datasets, function (idx, item) {
                html += '<th style="background-color:' + item.fillColor + ';">' + item.label + '</th>';
                columnCount += 1;
            });
            html += '</tr></thead>';
            jQuery.each(dataset.labels, function (idx, item) {
                html += '<tr><td>' + item + '</td>';
                for (var i = 0; i < columnCount; i++) {
                    html += '<td style="background-color:' +
                    dataset.datasets[i].fillColor +
                    ';">' +
                    (dataset.datasets[i].data[idx] === '0' ? '-' : dataset.datasets[i].data[idx]) +
                    '</td>';
                }
                html += '</tr>';
            });
            html += '</tr><tbody></table>';
            return html;
        };
        if (component.get("v.Titulo") === "Puntos BPyP") {
            helper.obtPuntos(component, event, helper, 'fetchPuntosBPP');
        }
        else {
            helper.obtPuntos(component, event, helper, 'fetchEUBPP');
        }
    },
})
