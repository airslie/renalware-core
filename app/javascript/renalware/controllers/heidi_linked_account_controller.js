import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]
  static values = {
    interval: { type: Number, default: 2000 },
    maxAttempts: { type: Number, default: 60 },
    url: String,
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.attempts = 0
    this.updateStatus("Waiting for Heidi account linking...")
    this.stopPolling()
    this.timer = window.setInterval(() => this.poll(), this.intervalValue)
  }

  async poll() {
    this.attempts += 1

    if (this.attempts > this.maxAttemptsValue) {
      this.stopPolling()
      this.updateStatus("Heidi account linking was not confirmed.")
      return
    }

    try {
      const response = await fetch(this.urlValue, {
        credentials: "same-origin",
        headers: { "Accept": "application/json" },
      })
      const body = await response.json()

      if (response.ok && body.is_linked) {
        this.stopPolling()
        this.updateStatus("Heidi account linked.")
        window.location.reload()
      }
    } catch (_error) {
      this.updateStatus("Checking Heidi account link status...")
    }
  }

  stopPolling() {
    if (this.timer) window.clearInterval(this.timer)
    this.timer = null
  }

  updateStatus(message) {
    if (this.hasStatusTarget) this.statusTarget.textContent = message
  }
}
