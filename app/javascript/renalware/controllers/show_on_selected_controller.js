/**
 * Show / hide targets depending on the value selected.
 *
 * Add `data-action="show-on-selected#select"` to the select tag
 * Add `data-show-on-selected-target="item"` to the fields to show / hide
 * Add `data-show-on-selected-option="<VALUE>"` to the fields to show / hide,
 * where <VALUE> is the value of the option or a JSON encoded array of options,
 * that when selected, should cause the field to be shown.
 *
 * Example useage with multiple options:
 *
 * ```
 * <section data-controller="show-on-selected">
 *  <select data-action="show-on-selected#select">
 *    <option value="test">Testing</option>
 *    <option value="best">Besting ?</option>
 *    <option value="rest">Resting</option>
 *  </select>
 *
 *   <div class="hidden"
 *    data-show-on-selected-target="item"
 *    data-show-on-selected-option="<%= ["test", "best"].to_json %>"
 *   >
 *    <input name="some_conditionaly_show_input"/>
 *   </div>
 * </section>
 * ```
 **/
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.toggleClass = this.data.get("class") || "hidden"
  }

  select(event) {
    event.preventDefault()

    const selectedOption = event.currentTarget.value

    this.itemTargets
      .filter((target) =>
        this.isMatch(target.dataset.showOnSelectedOption, selectedOption)
      )
      .forEach((target) => {
        target.classList.remove(this.toggleClass)

        Array.from(target.getElementsByTagName("input")).forEach((input) => {
          input.disabled = false
        })
      })

    this.itemTargets
      .filter(
        (target) =>
          !this.isMatch(target.dataset.showOnSelectedOption, selectedOption)
      )
      .forEach((target) => {
        target.classList.add(this.toggleClass)

        Array.from(target.getElementsByTagName("input")).forEach((input) => {
          input.disabled = true
        })
      })
  }

  isMatch(candidate, target) {
    let candidates = [this.parsePotentialJson(candidate)].flat()

    return candidates.includes(target)
  }

  // Support both "regular" strings and JSON encoded arrays for
  // data-show-on-selected-option attributes
  parsePotentialJson(valueOrJson) {
    try {
      return JSON.parse(valueOrJson)
    } catch (error) {
      return valueOrJson
    }
  }
}
