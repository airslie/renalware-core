import { Controller } from "stimulus"

// A test controller to establish that rollup + stimulus + babel are working
export default class extends Controller {
  connect() {
    this.element.textContent = "TestController connected."
  }
}
