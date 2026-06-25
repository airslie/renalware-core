import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "toggle", "disclosure", "panel"]

  connect() {
    this.closeAllDisclosures()
  }

  toggleMenu() {
    const expanded = this.toggleTarget.getAttribute("aria-expanded") === "true"

    this.element.classList.toggle("rw-primary-nav--open", !expanded)
    this.toggleTarget.setAttribute("aria-expanded", String(!expanded))
    if (expanded) this.closeAllDisclosures()
  }

  toggleDisclosure(event) {
    const button = event.currentTarget
    const panel = this.panelTargets.find(candidate => candidate.id === button.getAttribute("aria-controls"))

    if (!panel) return

    const expanded = button.getAttribute("aria-expanded") === "true"

    this.closeAllDisclosures(button)
    button.setAttribute("aria-expanded", String(!expanded))
    panel.hidden = expanded
  }

  closeAll() {
    this.closeMenu()
    this.closeAllDisclosures()
  }

  closeOnOutside(event) {
    if (this.element.contains(event.target)) return

    this.closeAll()
  }

  closeMenu() {
    if (!this.hasToggleTarget) return

    this.element.classList.remove("rw-primary-nav--open")
    this.toggleTarget.setAttribute("aria-expanded", "false")
  }

  closeAllDisclosures(exceptButton = null) {
    this.disclosureTargets.forEach(button => {
      if (button !== exceptButton) button.setAttribute("aria-expanded", "false")
    })

    this.panelTargets.forEach(panel => {
      if (exceptButton && panel.id === exceptButton.getAttribute("aria-controls")) return

      panel.hidden = true
    })
  }
}
