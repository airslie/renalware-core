import { Controller } from "stimulus"
import { Sortable } from "sortablejs"

// Simple controller to add sorting using drag and drop voa the sortablsjs library.
// Currently just sorts the doam and does not post to the server.
// Next:
// - specify class for handle, defaulting to .handle
// - default containerTarget to the ul that the controller is added to
// - support posting to the server to sort results.

export default class extends Controller {
  static targets = ["container"]

  connect() {
    Sortable.create(this.containerTarget, {
      handle: ".handle",
      animation: 150
    })
  }
}
