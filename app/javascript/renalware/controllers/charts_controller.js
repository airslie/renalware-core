import { Controller } from "stimulus"
import URLSearchParams from "@ungap/url-search-params"
import Highcharts from "highcharts"

export default class extends Controller {
  static targets = [
    "chart", // chart container
    "period" // array of period (10y, 3y..) links
  ]

  static values = {
    url: String,          // API endpoint for chart json
    title: String,        // Chart title
    period: String,       // State for the last selected period
    yAxisLabel: String,   // eg Kg
    yAxisType: String     // linear or logarithmic
  }

  static classes = [
    "currentPeriod"       // Maps to a CSS class name via data attribute on controller element
  ]

  initialize(){
    this.getJson()
    this.addCurrentPeriodClassToDefaultPeriod()
  }

  // A user clicked on a period link eg "3y"
  // Update the 'period' stimulus 'value' data attribute on the controller element in the DOM with
  // the data-period attribute on the clicked link, and then refresh the graph, which will request
  // json for the selected time period eg "3y"
  periodChanged(event) {
    this.periodValue = event.target.getAttribute("data-period")
    this.removeCurrentClassFromAllPeriods()
    this.addCurrentClassToSelectedPeriod(event.target)
    this.getJson()
  }

  removeCurrentClassFromAllPeriods() {
    this.periodTargets.forEach(function (el) {
      el.classList.remove("current-period")
    })
  }

  addCurrentPeriodClassToDefaultPeriod() {
    this.periodTargets.forEach(el => {
      if (el.getAttribute("data-period") == this.periodValue) {
        this.addCurrentClassToSelectedPeriod(el)
      }
    })
  }

  addCurrentClassToSelectedPeriod(el) {
    el.classList.add(this.currentPeriodClass)
  }

  updateChart(json) {
    Highcharts.chart(this.chartTarget, {
      chart: {
        zoomType: "x"
      },
      credits: {
        enabled: false
      },
      title: {
        text: this.titleValue,
        align: "left"
      },
      xAxis: {
        type: "datetime"
      },
      yAxis: {
        type: this.yAxisTypeValue,
        title: {
          text: this.yAxisLabelValue
        }
      },
      tooltip: {
        headerFormat: "<b>{series.name}</b><br>",
        pointFormat: "{point.x:%e-%b-%Y}: {point.y:.2f}"
      },
      plotOptions: {
        series: {
          animation: {
            duration: 500
          },
          marker: {
              enabled: true
          }
        }
      },
      series: json,
      responsive: {
        rules: [{
          condition: {
            maxWidth: 500
          },
          chartOptions: {
            plotOptions: {
              series: {
                marker: {
                    radius: 2.5
                }
              }
            }
          }
        }]
      }
    })
  }

  getJson() {
    fetch(this.urlValue + "?" + new URLSearchParams({ period: this.periodValue}), {
      credentials: "same-origin",
      headers: new Headers({"content-type": "application/json"})
    })
    .then(response => response.json())
    .then(json => {
      this.updateChart(json)
    })
  }
}
