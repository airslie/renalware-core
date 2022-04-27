//
// Adapted from https://github.com/excid3/tailwindcss-stimulus-components#tabs
//
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  connect() {
  }

  initialize() {
    this.activeTabClasses = (this.data.get("activeTab") || "active").split(" ")
    this.showTab()
  }

  change(event) {
    event.preventDefault()
    this.index = this.tabTargets.indexOf(event.currentTarget)
  }

  showTab() {
    this.tabTargets.forEach((tab, index) => {
      const panel = this.panelTargets[index]

      if (index === this.index) {
        panel.classList.remove("hidden")
        tab.classList.add(...this.activeTabClasses)
      } else {
        panel.classList.add("hidden")
        tab.classList.remove(...this.activeTabClasses)
      }
    })
  }

  get index() {
    return parseInt(this.data.get("index") || 0)
  }

  set index(value) {
    this.data.set("index", value)
    this.showTab()
  }
}
