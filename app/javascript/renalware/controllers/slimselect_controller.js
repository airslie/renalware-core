//
// Src: https://github.com/excid3/stimulus-slimselect
//

import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  static values = {
    options: Object
  }

  connect() {
    this.slimselect = new SlimSelect({
      select: this.element,
      ...this.optionsValue
    })
  }

  disconnect() {
    this.slimselect.destroy()
  }
}
