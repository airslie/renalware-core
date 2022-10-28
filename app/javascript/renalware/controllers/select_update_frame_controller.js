import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    frameId: String,
  }

  change(event) {
    const selectedValue = event.currentTarget.selectedOptions[0].value
    const url = this.urlValue.replace("OPTION_VALUE", selectedValue)
    const frame = document.getElementById(this.frameIdValue)
    frame.src = url
  }
}
