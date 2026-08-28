import { Controller } from "@hotwired/stimulus"
import Highcharts from "highcharts"

export default class extends Controller {
  static targets = [
    "chart", // chart container
  ]

  static values = {
    url: String,          // API endpoint for chart json
    config: Object,       // Or chart options embedded directly in the page
  }

  connect(){
    if (this.hasConfigValue) {
      this.updateChart(this.configValue)
    } else if (this.hasUrlValue) {
      this.getJson()
    }
  }

  updateChart(json) {
    Highcharts.chart(this.chartTarget, json)
  }

  getJson() {
    fetch(this.urlValue, {
      credentials: "same-origin",
      headers: new Headers({"content-type": "application/json"})
    })
    .then(response => response.json())
    .then(json => {
      this.updateChart(json)
    })
  }
}
