// NB Chartkick and Highcharts are defined as global in rollup
const Chartkick = window.Chartkick

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "chart" ]

  // Called on ajax:success
  redisplay(event) {
    // let [json, status, xhr] = event.detail
    let json = event.detail[0]
    if (this.chartCreated()) {
      this.chartTarget.getChartObject().updateData(json)
    } else {
      new Chartkick.LineChart("chart1", json, this.chartOptions)
    }
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
              duration: 400
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
