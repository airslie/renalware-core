import { Controller } from "stimulus"

// Used when a table has toggleable rows (initially hidden rows that can be toggled open
// to see e.g. notes or extended details) and each master row and its toggleable sibling are
// nested in a tbody (this is valid HTML) - ie there are probably two trs per tbody, and the last
// one is toggleable. If you need anyting more complex you'll need to clone or adapt this
// controller
export default class extends Controller {
  // This handler toggles the last tr in the current tbody. We use multiple tbodys in each table
  // to make toggling like this simpler, and to group the related (visible and toggleable) rows
  // together.
  row(event) {
    event.preventDefault
    const tbody = event.target.closest("tbody")
    tbody.classList.toggle("toggleable--open")
    // Update masonry - TODO: move to a module
    $('.grid > .row').masonry('layout')
  }

  // Toggle the last tr in each tbody in the current table.
  // The link that triggers this event will most likelt be a double chevron icon
  // sitting in a thead.
  table(event) {
    event.preventDefault
    const table = event.target.closest("table")
    const thead = event.target.closest("thead")
    // Use an Array rather a NodeList here as IE does not support NodeList.forEach
    const tbodies = Array.prototype.slice.call(table.querySelectorAll("tbody"))
    const hide = thead.classList.contains("toggleable--open")
    thead.classList.toggle("toggleable--open")
    tbodies.forEach(function(tbody) { tbody.classList.toggle("toggleable--open", !hide) })
    // Update masonry - TODO: move to a module
    $('.grid > .row').masonry('layout')
  }
}
