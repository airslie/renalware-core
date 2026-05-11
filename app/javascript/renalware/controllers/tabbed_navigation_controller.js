import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (this.element.classList.contains("no-js-selection")) return

    this.element.querySelectorAll("dd").forEach((tab) => {
      const href = tab.querySelector("a")?.getAttribute("href")
      if (href && new URL(href, window.location.origin).pathname === window.location.pathname) {
        tab.classList.add("active")
      }
    })
  }
}
