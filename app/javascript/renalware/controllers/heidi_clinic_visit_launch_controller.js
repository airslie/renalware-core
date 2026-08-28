import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    closePreparationTab: { type: Boolean, default: false },
    url: String,
  }

  connect() {
    if (this.closePreparationTabValue) this.closePreparationTab()
  }

  open(_event) {
    if (!this.element.checkValidity()) {
      this.element.reportValidity()
      return
    }

    window.open(this.urlValue, "renalware-heidi-session")
  }

  closePreparationTab() {
    const heidiWindow = window.open("", "renalware-heidi-session")
    if (heidiWindow) heidiWindow.close()
  }
}
