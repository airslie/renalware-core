import { Controller } from "@hotwired/stimulus"
const $ = window.$

export default class extends Controller {
  static targets = ["container","radio"]

  connect() {
    window.initDatepickersIn(".hd-drug-administration")
  }

  toggleAdministered() {
    var checked = event.target.value == "true"
    this.containerTarget.classList.toggle("administered", checked)
    this.containerTarget.classList.toggle("not-administered", !checked)
    this.containerTarget.classList.remove("undecided")
    // The rest of this actions are using jQuery for now.
    $(".authentication", this.containerTarget).toggle(checked)
    $(".authentication", this.containerTarget).toggleClass("disabled-with-faded-overlay", !checked)
    $(".reason-why-not-administered", this.containerTarget).toggle(!checked)
    $("#btn_save_and_witness_later").toggle(checked)
  }
}
