import { Controller } from "stimulus"

// Used with patient attachments aka linked files.
export default class extends Controller {
  static targets = [ "fileBrowser", "externalLocation" ]

  // When the attachment type changes we examine a data attribute on the selected option
  // and show/hide the relevant file input (a text input if its an external stored, otherwise
  // a conventional file input).
  toggleFileInputs(event) {
    let selectedOption = event.target.querySelector("option:checked")
    let storeFileExternally = ("true" == selectedOption.getAttribute("data-store-file-externally"))
    this.fileBrowserTarget.style.display = storeFileExternally ? "none" : "block"
    this.externalLocationTarget.style.display = storeFileExternally ? "block" : "none"
  }
}
