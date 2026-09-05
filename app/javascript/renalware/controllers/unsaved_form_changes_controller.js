import { Controller } from "@hotwired/stimulus"

/*
  Warns the user with the browser's native "leave page?" prompt if they try to
  navigate away (close tab, refresh, click a link, use the back button) from a
  form containing unsaved changes.

  Usage: add `data: { controller: "unsaved-form-changes" }` to any <form>.

  Dirtiness is determined by comparing the form's current serialized values
  against a snapshot taken shortly after connecting, rather than by tracking
  individual input events. This means reverting a change (e.g. typing then
  deleting a character) does not trigger the warning, and other controllers
  (Trix, SlimSelect, etc) that set field values programmatically are picked up
  automatically without needing bespoke event wiring.
*/
export default class extends Controller {
  connect() {
    this.submitting = false
    this.onSubmit = this.onSubmit.bind(this)
    this.onBeforeUnload = this.onBeforeUnload.bind(this)

    this.element.addEventListener("submit", this.onSubmit)
    window.addEventListener("beforeunload", this.onBeforeUnload)

    // Deferred so that other controllers/custom elements on the form (Trix,
    // SlimSelect, ...) have finished setting their initial values before we
    // snapshot it. Uses setTimeout rather than requestAnimationFrame because
    // rAF callbacks are suspended while the tab is backgrounded/hidden, which
    // would leave snapshot unset (and the warning permanently disabled) for a
    // page that loads in a background or unfocused tab.
    setTimeout(() => {
      this.snapshot = this.serialize()
    }, 0)
  }

  disconnect() {
    this.element.removeEventListener("submit", this.onSubmit)
    window.removeEventListener("beforeunload", this.onBeforeUnload)
  }

  onSubmit() {
    this.submitting = true
  }

  onBeforeUnload(event) {
    if (this.submitting || !this.dirty) return

    event.preventDefault()
    event.returnValue = ""
    return ""
  }

  get dirty() {
    return this.snapshot !== undefined && this.serialize() !== this.snapshot
  }

  serialize() {
    const params = new URLSearchParams()

    for (const [key, value] of new FormData(this.element).entries()) {
      params.append(key, value instanceof File ? `${value.name}:${value.size}` : value)
    }

    return params.toString()
  }
}
