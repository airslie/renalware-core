const $ = window.$
import { Controller } from "stimulus"

export default class extends Controller {
  insert(event) {
    // Note the trix_edito_helper is not inserting the correct class atm
    // so for now we are just selecting the one and only (hopefully) trix-editor on the page
    // let editorSelector = this.data.get("target-input")
    let modal = $("#snippets-modal")
    let snippetBody = $(event.target).parent().closest("tr").find(".body").html()
    let targetInputSelector = $(modal).data("target")
    trix = document.querySelector("trix-editor")
    trix.editor.insertHTML(snippetBody)
    $(modal).foundation("reveal", "close")
  }
}
