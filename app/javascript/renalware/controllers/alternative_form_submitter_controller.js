import { Controller } from "@hotwired/stimulus"

/*  Allows to submit an form that's different to the
   form the input is attached to. All fields that are
   part of the main form at submitted to the alternative
   form.

   Example:

   Define an empty form outside of the current form:

  = form_with url: search_url, id: "inner_drug_select_form", data: { turbo_frame: "inner_drug_select_form_frame" }, method: :get do |select_form|

  Then, specify an action that will trigger the submit of the "empty" form:

  = simple_form_for prescription, url: update_url do |f|
    = f.input_field :field,
      as: :toggle,
      data: { "action": "change->alternative-form-submitter#submit" }
*/

export default class extends Controller {
  static targets = ["form"]

  submit(event) {
    const targetForm =
      document.getElementById(event.target.dataset.alternativeForm) ||
      this.formTarget

    Array.from(event.target.form.elements).forEach((element) => {
      element.setAttribute("form", targetForm.id)
    })

    targetForm.requestSubmit()

    Array.from(event.target.form.elements).forEach((element) => {
      element.removeAttribute("form")
    })
  }
}
