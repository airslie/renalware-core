import { Controller } from "@hotwired/stimulus"

// Given the markup eg
//   ul.side-nav(data-controller="navbar"
//               data-navbar-rails-controller-value="xxx"
//               data-navbar-active-class="some css class")
//    li(data-navbar-target="nav" data-url="clinical/profiles")
//      a(href..) An menu item
// When the controller connects it will add a css class to any nav target where the
// the nav's data-rails-controller-regex matches the value specified by the current
// rails controller in the execution path ie data-navbar-rails-controller-value.
// Using js to highlight the menu on this context means we can cache it's partial.
export default class extends Controller {
  static targets = ["nav"]
  static values = { railsController: String }
  static classes = ["active"]

  connect() {
    this.navTargets.forEach(nav => {
      regex = new RegExp(nav.dataset.railsControllerRegex, "i")
      if(regex.test(this.railsControllerValue) == true) {
        nav.classList.add(this.activeClass)
      }
    })
  }
}
