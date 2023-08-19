import { Controller } from "@hotwired/stimulus"

// Set all radio inputs within the controller's element to checked if their
// value = matchValue (eg "no" in the case of tristate Yes No Unknown radio
// groups).
// Example usage:
// div(data-controller="radio-reset" data-radio-reset-match-value="no")
//   input(type="radio" value="yes" ..)
//   input(type="radio" value="no" ..)
//   ...

export default class extends Controller {
  static values = { match: String }

  reset_all(event) {
    const that = this
    const radioInputs = Array.prototype.slice.call(
      this.element.querySelectorAll("input[type='radio']")
    )
    radioInputs.forEach(function(a){
      if (a.value == that.matchValue) { a.checked = true }
    })
  }
}
