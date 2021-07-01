import { Controller } from "stimulus"
const Rails = window.Rails

export default class extends Controller {
  refresh(event) {
    event.preventDefault()
    let selectedOption = this.element.options[this.element.selectedIndex]
    let url = selectedOption.dataset.source
    Rails.ajax({
      type: "GET",
      url: url,
      dataType: "application/js"
    })
  }
}
