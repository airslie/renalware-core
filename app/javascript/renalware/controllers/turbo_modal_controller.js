import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // console.log("ss")
  }

  submitEnd() {
    // console.log("submitEnd")
  }

  close(e) {
    e.preventDefault()
    this.element.remove()
  }
}
