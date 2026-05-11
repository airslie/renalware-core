import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "initialFocus"]

  open(event) {
    event.preventDefault()
    this.dialogTarget.showModal()

    if (this.hasInitialFocusTarget) {
      this.initialFocusTarget.focus()
    }
  }

  close(event) {
    event.preventDefault()
    this.dialogTarget.close()
  }

  backdropClose(event) {
    if (event.target === this.dialogTarget) {
      this.dialogTarget.close()
    }
  }
}
