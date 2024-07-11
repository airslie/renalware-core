const $ = window.$
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  insert(event) {
    // // TODO: set up the trix editor in each page as data-target="snippets.trix"
    // let modal = $("#snippets-modal")
    // let snippetBody = $(event.target).parent().closest("tr").find(".body").html()
    // let trix = document.querySelector("trix-editor")
    // trix.editor.insertHTML(snippetBody)
    // $(modal).foundation("reveal", "close")
  }
}
