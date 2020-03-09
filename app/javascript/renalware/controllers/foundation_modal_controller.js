const $ = window.$
import { Controller } from "stimulus"

// Controller for handling Foundation 'reveal' dialogs.
// Assumes jQuery and foundation/reveal available.
// The .container target is the html element the .reveal-modal class into which
// the remote content will be loaded. Using a named target rather finding
// .reveal-modal in case there are nested modal-controllers and >1 of this
// elements exist in scope.
export default class extends Controller {
  static targets = [ "container" ]

  // Open a dialog using a url to load a partial via ajax.
  openRemotePartial() {
    $(this.containerTarget).html("") // prevent old content from being initially re-displayed
    url = this.data.get("url")
    $(this.containerTarget).load(url).foundation('reveal', 'open');
  }
}
