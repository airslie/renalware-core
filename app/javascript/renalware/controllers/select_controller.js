import { Controller } from "@hotwired/stimulus"
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

  /*
  When each option in a select has data-show and/or data-hide attributes
  specifying the ids (currently only one id supported) of elements to show or
  hide. Used for example when selecting an option should show a certain UI element
  and other options should hide it. Used e.g. on the AKI alerts filter form for the
  specific data option.
  */
  showhide(event) {
    let selectedOption = this.element.options[this.element.selectedIndex]
    let idsToShow = selectedOption.dataset.show
    let idsToHide = selectedOption.dataset.hide
    document.querySelector("#" + idsToShow)?.classList.remove("hidden")
    document.querySelector("#" + idsToHide)?.classList.add("hidden")
  }
}
