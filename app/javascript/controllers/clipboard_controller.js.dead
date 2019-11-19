import { Controller } from "stimulus"

// Experimental Stimulus clipboard controller. No IE11 support.
// Can be enhanced but initially this exists just so we can test stimulus/webpack integration
// when the engine is pulled into a host app
export default class extends Controller {
  static targets = ["source", "result"]

  copy(event) {
    event.preventDefault()
    this.sourceTarget.select()
    document.execCommand("copy")
    console.log("Copied")
    this.resultTarget.innerHTML = "Copied"
  }
}
