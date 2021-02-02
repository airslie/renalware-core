import { Controller } from "stimulus"

// Controller to enable collapsing elements of a nav/menu to for example
// allow a more dense menu that can simplifies by hiding/collapsing sections.
//
// Example slim markup:
//
// div(data-controller="collapsible" data-collapsible-open-class="open")
//   a(data-action="collapsible#open" data-collapsible-target="link" href="#") X
//   div.collapsible(data-collapsible-target="section")
//     p XXX
//   a(data-action="collapsible#open" data-collapsible-target="link" href="#") Y
//   div.collapsible(data-collapsible-target="section")
//     p YYY
export default class extends Controller {
  static targets = [ "section", "link" ]
  static classes = [ "open" ]

  connect() {
    // TODO: We could support an initial open section here for example.
  }

  // When a user clicks on a link with the target of "link", we determine its index,
  // hide all "section" targets initially, then just show the section with the
  // current index. This is a similar approach to the one we take with the tabs controller.
  open(event) {
    let index = this.linkTargets.indexOf(event.currentTarget)

    this.sectionTargets.forEach((elem, idx) => {
      elem.classList.remove(this.openClass)
      if (idx == index) {
        elem.classList.add(this.openClass)
      }
    })
  }
}
