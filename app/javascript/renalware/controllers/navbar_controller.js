import { Controller } from "@hotwired/stimulus"

// Given the markup eg
//   ul.side-nav(data-controller="navbar"
//               data-navbar-rails-controller-value="xxx"
//               data-navbar-active-class="some css class")
//    li(data-navbar-target="nav" data-rails-controller="clinical/profiles")
//      a(href..) An menu item
// When the controller connects it will add a css class to any nav target where the
// the nav's data-rails-controller string occurs at the start of the rails controller value
// eg for current controller pathology/historical, the nav with data-rails-controller="pathology"
// will get the active class.
// Using js to highlight the menu on this context means we can cache it's partial.
export default class extends Controller {
  static targets = ["nav"]
  static values = { railsController: String }
  static classes = ["active"]

  connect() {
    this.navTargets.forEach(nav => {
      if (this.railsControllerValue.startsWith(nav.dataset.railsController)) {
        nav.classList.add(this.activeClass)
      }
    })
  }
}
