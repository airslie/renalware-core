import { Controller } from "@hotwired/stimulus"

// Inspired by https://stackoverflow.com/a/56952952/4405214
export default class extends Controller {
  connect() {
    this.doubleScroll(this.element)
  }

  doubleScroll(element) {
    const scrollbar = document.createElement("div")
    scrollbar.appendChild(document.createElement("div"))
    scrollbar.style.overflow = "auto"
    scrollbar.style.overflowY = "hidden"
    scrollbar.firstChild.style.width = element.scrollWidth + "px"
    scrollbar.firstChild.style.paddingTop = "1px"
    let running = false
    // Keep scrollbar in sync when element size changes
    new ResizeObserver(() => {
      scrollbar.firstChild.style.width = element.scrollWidth + "px"
    }).observe(element)

    scrollbar.onscroll = function () {
      if (running) {
        running = false
        return
      }
      running = true
      element.scrollLeft = scrollbar.scrollLeft
    }

    element.onscroll = function () {
      if (running) {
        running = false
        return
      }
      running = true
      scrollbar.scrollLeft = element.scrollLeft
    }

    element.parentNode.insertBefore(scrollbar, element)
  }
}
