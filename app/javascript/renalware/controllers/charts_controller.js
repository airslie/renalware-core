const $ = window.$

import "promise-polyfill/src/polyfill"
import "classlist.js/classList.js"

import { Controller } from "stimulus"
import ApexCharts from "apexcharts"

export default class extends Controller {
  static targets = [ "chart", "obx", "period", "patientId" ]

  connect() {
    new ApexCharts(this.chartTarget, this.chartOptions).render()
    this.refresh()
  }

  // Note that the chart if eg #chart1 needs to be in the chart options in connect()
  refresh() {
    console.log(this.obx)
    this.clearChart()
    let params = { obx: this.obx, period: this.period, patient_id: this.patientId }
    $.getJSON(this.url, params, (response) => {
      ApexCharts.exec(this.chartTarget.id, "updateSeries", [{
        name: this.obx,
        data: response
      }])
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

  get chartOptions() {
    return {
      chart: {
        id: this.chartTarget.id,
        type: "area"
      },
      animations: {
        enabled: false
      },
      stroke: {
        width: 1
      },
      dataLabels: {
        enabled: false
      },
      series: [],
      xaxis: {
        categories: []
      }
    }
  }

  clearChart() {
    ApexCharts.exec(this.chartTarget.id, "updateOptions", [{
      series: [
        {
          name: this.obx,
          data: []
        }
      ]
    }])
  }
}
