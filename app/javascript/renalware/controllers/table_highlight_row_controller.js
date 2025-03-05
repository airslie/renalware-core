import { Controller } from "@hotwired/stimulus"

// Used to highlight just one row in a table when it is clicked.
export default class extends Controller {
  static targets = ["row"]

  select(event) {
    // Get the row (tr) that contains the clicked link
    const clickedRow = event.currentTarget.closest("tr")

    // Add the selected class to the clicked row and remove from siblings
    this.rowTargets.forEach(row => {
      if (row === clickedRow) {
        row.classList.add("is-selected")
      } else {
        row.classList.remove("is-selected")
      }
    })
  }
}
