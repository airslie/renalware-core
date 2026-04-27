import { Controller } from "@hotwired/stimulus"

// Handles the modal dialog used for presenting Home Delivery print options to
// the user. Used on the prescriptions page.
export default class extends Controller {
  static targets = [
    "administerOnHd",
    "fixedDose",
    "fixedDoseContainer",
    "hdOptions",
    "homeDeliveryDates",
    "providers",
    "stat",
    "statContainer"
  ]

  connect() {
    if (this.hasProvidersTarget) {
      const checkedProvider = this.providersTarget.querySelector("input:checked")
      if (checkedProvider) this.toggleDeliveryDatesVisibility(checkedProvider.value)
    }

    this.toggleHdDoseOptions()
  }

  toggleDeliveryDates(event) {
    this.toggleDeliveryDatesVisibility(event.target.value)
  }

  selectHdDefaultProvider(event) {
    if (!event.target.checked) return

    const defaultProviderForHd = this.providersTarget.querySelector("input[data-default-for='hd']")
    if (!defaultProviderForHd || defaultProviderForHd.checked) return

    defaultProviderForHd.checked = true
    defaultProviderForHd.dispatchEvent(new Event("change", { bubbles: true }))
  }

  toggleHdPrescriptionOptions(event) {
    this.selectHdDefaultProvider(event)

    if (!event.target.checked) {
      this.statTarget.checked = false
      this.fixedDoseTarget.value = ""
    }

    this.toggleHdDoseOptions()
  }

  toggleHdDoseOptions() {
    if (!this.hasAdministerOnHdTarget) return

    this.hdOptionsTarget.classList.toggle("hidden", !this.administerOnHdTarget.checked)
    if (!this.administerOnHdTarget.checked) return

    if (this.statTarget.checked) {
      this.fixedDoseTarget.value = ""
    } else if (this.fixedDoseTarget.value !== "") {
      this.statTarget.checked = false
    }

    this.statContainerTarget.classList.toggle("hidden", this.fixedDoseTarget.value !== "")
    this.fixedDoseContainerTarget.classList.toggle("hidden", this.statTarget.checked)
  }

  toggleDeliveryDatesVisibility(radio_value) {
    if (radio_value == "home_delivery") {
      this.homeDeliveryDatesTarget.style.display = "block"
    } else {
      this.homeDeliveryDatesTarget.style.display = "none"
    }
  }
}
