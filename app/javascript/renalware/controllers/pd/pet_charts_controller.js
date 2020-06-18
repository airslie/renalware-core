// NB Chartkick and Highcharts are defined as global in rollup
const Highcharts = window.Highcharts // Highcharts is defined as global in rollup
const $ = window.$
import { Controller } from "stimulus"
import more from "highcharts/highcharts-more"
more(Highcharts)

export default class extends Controller {
  connect() {
    $.getJSON(
      this.data.get("url"),
      (data) => {
        Highcharts.chart(this.element, {
          chart: {
            scrollablePlotArea: {
              minWidth: 600,
              scrollPositionX: 1
            }
          },
          title: {
            //text: "Peritoneal Equilibration Test",
            text: "",
            align: "left"
          },
          subtitle: {
            text: "",
            align: "left"
          },
          xAxis: {
            title: {
              text: "D/P creatinine (4hrs)"
            },
            type: "linear",
            labels: {
              overflow: "justify"
            },
            plotBands: [{
              from: 0.3,
              to: 0.5,
              color: "rgba(68, 170, 213, 0.1)",
              label: {
                text: "Low",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: 0.5,
              to: 0.65,
              color: "rgba(0, 0, 0, 0)",
              label: {
                text: "Low average",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: 0.65,
              to: 0.82,
              color: "rgba(68, 170, 213, 0.1)",
              label: {
                text: "High average",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: 0.82,
              to: 1.0,
              color: "rgba(0, 0, 0, 0)",
              label: {
                text: "High",
                style: {
                  color: "#606060"
                }
              }
            }]
          },
          yAxis: {
            title: {
              text: "Net Ultrafiltration (mls)"
            },
            tickInterval: 200,
            minorGridLineWidth: 0,
            gridLineWidth: 0,
            alternateGridColor: null,
            floor: -600,
            plotLines: [{
                    color: "#BBB",
                    width: 1,
                    value: 0
                }]
          },

          tooltip: {
            formatter: function () {
              return "<br>D_Pcr <b>" + this.x + "</b><br>" +
                  "netUF <b>" + this.y + "</b>"
            }
          },
          plotOptions: {
            pointStart: 0.3,
            line: {
              dataLabels: {
                enabled: true,
                format: "{point.index}",
                style: {
                  fontSize: "15px"
                }
              }
            },
            series: {
              enableMouseTracking: false
            },
            dataLabels: {
              enabled: true,
              style: {
                fontWeight: "bold"
              }
            }
          },
          series: [
          {
            name: "Expected",
            color: "#00a499", //"#D970D9",
            showInLegend: true,
            type: "polygon",
            data: [
              [0.36,400],
              [0.36,1000],
              [0.5,1000],
              [0.9,600],
              [0.9,300],
              [0.6,100],
              [0.36,400]
            ]
          },
          {
            name: "Warning",
            color: "#fff495",
            showInLegend: true,
            type: "polygon",
            data: [
              [0.6,100],
              [0.9,300],
              [1.0,200],
              [1.0,-600],
              [0.75,-600],
              [0.6,100]
            ]
          },
          {
            // patient data
            color: "#040481",
            showInLegend: false,
            enableMouseTracking: true,
            data: data
          }],
          navigation: {
            menuItemStyle: {
              fontSize: "10px"
            }
          }
        })
        this.element.style.overflow = "unset"
      }
    )
  }
}
