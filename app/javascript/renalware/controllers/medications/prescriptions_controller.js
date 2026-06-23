import { Controller } from "@hotwired/stimulus"

// Handles the modal dialog used for presenting Home Delivery print options to
// the user. Used on the prescriptions page.
export default class extends Controller {
  static targets = [
    "administerOnHd",
    "homeDeliveryDates",
    "providers"
  ]

  connect() {
    if (this.hasProvidersTarget) {
      const checkedProvider = this.providersTarget.querySelector("input:checked")
      if (checkedProvider) this.toggleDeliveryDatesVisibility(checkedProvider.value)

      const radioValue = this.providersTarget.querySelector("input:checked")?.value
      if (radioValue) this.toggleDeliveryDatesVisibility(radioValue)
    }
  }

  toggleDeliveryDates(event) {
    this.toggleDeliveryDatesVisibility(event.target.value)
  }

  selectDefaultProvider(event) {
    if (event && !event.target.checked) return
    if (!this.hasProvidersTarget) return
    const defaultProvider = this.defaultProviderFor(event.target.value)
    if (!defaultProvider || defaultProvider.checked) return

    defaultProvider.checked = true
    defaultProvider.dispatchEvent(new Event("change", { bubbles: true }))
  }

  defaultProviderFor(administrationContext) {
    return Array.from(this.providersTarget.querySelectorAll("input[data-default-for]")).find(
      (provider) => provider.dataset.defaultFor.split(" ").includes(administrationContext)
    )
  }

  toggleHdPrescriptionOptions(event) {
    this.selectHdDefaultProvider(event)
  }

  toggleDeliveryDatesVisibility(radio_value) {
    if (radio_value == "home_delivery") {
      this.homeDeliveryDatesTarget.style.display = "block"
    } else {
      this.homeDeliveryDatesTarget.style.display = "none"
    }
  }
}
