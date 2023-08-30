import { Controller } from "@hotwired/stimulus"
const $ = window.$

/*
When this is controller is added to a table, if the table uses colgroups (eg historical pathology)
then as the mouse enters and leaves
*/
export default class extends Controller {
  connect() {
    this.element.addEventListener('mouseenter', e => { this.highlight_colgroup(e) }, true)
    this.element.addEventListener('mouseleave', e => { this.unhighlight_colgroup(e) }, true)
  }

  highlight_colgroup(e) {
    if (e.target.tagName == "TD") {
      $("colgroup").eq($(e.target).index()).addClass("hover");
    }
  }

  unhighlight_colgroup(e) {
    if (e.target.tagName == "TD") {
      $("colgroup").eq($(e.target).index()).removeClass("hover")
    }
  }
}
