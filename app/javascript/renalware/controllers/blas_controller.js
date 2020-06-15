// NB Chartkick and Highcharts are defined as global in rollup
const Highcharts = window.Highcharts

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "chart", "title" ]

  // E.g. clicked on/hovered over a link so we fetch the json for this anchor's url
  // and repopulate the graph
  show(e) {
    e.preventDefault()
    fetch(e.currentTarget.href)
    .then(response => response.json())
    .then(data => this.refreshChart(data))
  }

  refreshChart(seriesData) {
    // Could use chart title instead
    this.titleTarget.innerHTML = `${seriesData.code} (${seriesData.name})`
    let options = this.chartOptions
    options["series"] = [{ name: seriesData.code, data: seriesData.results }]
    Highcharts.chart(this.chartTarget.id, options)
  }

  get chartOptions() {
    return {
      chart: {
        type: "line"
      },
      xAxis: {
        type: "date"
      },
      series: []
    }
  }
}
