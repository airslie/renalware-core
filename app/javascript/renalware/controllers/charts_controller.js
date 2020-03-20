const $ = window.$
const Chartkick = window.Chartkick

// import "promise-polyfill/src/polyfill"
// import "classlist.js/classList.js"

import { Controller } from "stimulus"

// import Chartkick from "chartkick" - now a global
// import Highcharts from "highcharts" - now a global

export default class extends Controller {
  static targets = [ "chart", "obx", "period", "patientId" ]

  connect() {
    // Display the first time the page is loaded. Uses whatever the default
    // selected options are in selects etc.
    this.refresh()
  }

  // Get JSON from the server and display it in the graph
  refresh() {
    let params = { obx: this.obx, period: this.period, patient_id: this.patientId }
    $.getJSON(this.url, params, (response) => {
      if (this.chartCreated()) {
        this.chartTarget.getChartObject().updateData(response)
      } else {
        new Chartkick.LineChart("chart1", response, this.chartOptions)
      }
    })
  }

  get obx() {
    let select = this.obxTarget
    return select.options[select.selectedIndex].value
  }

  get period() {
    let select = this.periodTarget
    return select.options[select.selectedIndex].value
  }

  get patientId() {
    return this.patientIdTarget.value
  }

  get url() {
    return this.data.get("url")
  }

  // Returns true if the chart target has already been initialised
  chartCreated() {
    return Object.prototype.hasOwnProperty.call(this.chartTarget, "getChartObject")
  }

  get chartOptions() {
    return {
      curve: false,
      library: {
        chart: {
          zoomType: "x"
        },
        plotOptions: {
          series: {
            animation: {
              duration: 300
            }
          }
        },
        colors: [
          "#005eb8",
          "#009639",
          "#434348",
          "#90ed7d",
          "#f7a35c",
          "#8085e9",
          "#f15c80",
          "#e4d354"
        ]
      }
    }
  }
}
