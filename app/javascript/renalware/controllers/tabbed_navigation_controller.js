const $ = window.$
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $(".sub-nav:not('.no-js-selection') dd").each(function(){
      let href = $(this).find("a").attr('href')
      if (href === window.location.pathname) {
        $(this).addClass('active')
      }
    })
  }
}
