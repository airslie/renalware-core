import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  open() {
    window.open(this.urlValue, "renalware-heidi-session")
  }
}
