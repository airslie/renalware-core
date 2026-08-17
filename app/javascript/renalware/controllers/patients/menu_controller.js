import { Controller } from "@hotwired/stimulus"

const COLLAPSED_CLASS = "collapse-patient-menu"
const ALWAYS_COLLAPSED_CLASS = "always-collapse-patient-menu"

export default class extends Controller {
  static targets = ["mobileIndicator", "toggle"]

  connect() {
    this.refreshMasonry = this.refreshMasonry.bind(this)
    this.syncToScreenSize()
  }

  disconnect() {
    clearTimeout(this.resizeTimer)
    clearTimeout(this.masonryTimer)
    document.body.removeEventListener("transitionend", this.refreshMasonry)
  }

  toggle() {
    document.body.addEventListener("transitionend", this.refreshMasonry, {
      once: true
    })
    document.body.classList.toggle(COLLAPSED_CLASS)
    this.updateToggleState()
  }

  resize() {
    clearTimeout(this.resizeTimer)
    this.resizeTimer = setTimeout(() => {
      this.syncToScreenSize()
      this.scheduleMasonryRefresh()
    }, 200)
  }

  syncToScreenSize() {
    if (!document.body.classList.contains(ALWAYS_COLLAPSED_CLASS)) {
      document.body.classList.toggle(COLLAPSED_CLASS, this.mobileIndicatorIsVisible)
    }
    this.updateToggleState()
  }

  updateToggleState() {
    const expanded = !document.body.classList.contains(COLLAPSED_CLASS)
    this.toggleTarget.setAttribute("aria-expanded", expanded.toString())
  }

  scheduleMasonryRefresh() {
    clearTimeout(this.masonryTimer)
    this.masonryTimer = setTimeout(this.refreshMasonry, 300)
  }

  refreshMasonry() {
    if (window.Renalware && window.Renalware.MasonryHelper) {
      window.Renalware.MasonryHelper.refresh()
    }
  }

  get mobileIndicatorIsVisible() {
    return window.getComputedStyle(this.mobileIndicatorTarget).display !== "none"
  }
}
