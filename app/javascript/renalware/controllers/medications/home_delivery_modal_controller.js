const $ = window.$
import { Controller } from "stimulus"

// Handles the modal dialog used for presenting Home Delivery print options to
// the user. Used on the prescrptions page.
export default class extends Controller {
  static targets = [ "form", "printOptions", "printFeedback" ]

  // Submit and re-display the form when 'drug type' or 'prescription duration'
  // dropdowns are changed
  refreshForm() {
    $(this.formTarget[0]).trigger('submit.rails');
  }

  // When the user has clicked Print (launching the PDF in a new tab), hide
  // the Print button and display content which asks whether printing was
  // successful or not. Click one of these 2 buttons will dismiss the modal.
  // FYI if they say Yes (printing was a success) the home delivery
  // event (the object 'behind' our modal form) is updated with printed=true.
  askForPrintFeedback() {
    this.printOptionsTarget.classList.toggle("visuallyhidden")
    this.printFeedbackTarget.classList.toggle("visuallyhidden")
  }
}
