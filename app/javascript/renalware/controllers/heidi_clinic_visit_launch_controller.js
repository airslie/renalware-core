import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  static values = {
    accountUrl: String,
    closePreparationTab: { type: Boolean, default: false },
    interval: { type: Number, default: 2000 },
    maxAttempts: { type: Number, default: 60 },
    preparationUrl: String,
    statusUrl: String,
  }

  connect() {
    if (!this.hasButtonTarget) return

    if (this.closePreparationTabValue) this.closePreparationTab()
    this.checkLinkStatus()
  }

  disconnect() {
    this.stopPolling()
  }

  open(event) {
    if (this.state === "unlinked") {
      event.preventDefault()
      window.open(this.accountUrlValue, "renalware-heidi-account-link")
      this.startPolling()
      return
    }

    if (this.state !== "linked") {
      event.preventDefault()
      return
    }

    if (!this.element.checkValidity()) {
      event.preventDefault()
      this.element.reportValidity()
      return
    }

    window.open(this.preparationUrlValue, "renalware-heidi-session")
  }

  closePreparationTab() {
    const heidiWindow = window.open("", "renalware-heidi-session")
    if (heidiWindow) heidiWindow.close()
  }

  async checkLinkStatus() {
    this.setChecking()

    try {
      const response = await fetch(this.statusUrlValue, {
        credentials: "same-origin",
        headers: { "Accept": "application/json" },
      })
      const body = await response.json()

      if (response.ok && body.is_linked) {
        this.setLinked()
      } else if (response.ok) {
        this.setUnlinked()
      } else {
        this.setUnavailable()
      }
    } catch {
      this.setUnavailable()
    }
  }

  startPolling() {
    this.attempts = 0
    this.setChecking("Waiting for Heidi account link...")
    this.stopPolling()
    this.timer = window.setInterval(() => this.poll(), this.intervalValue)
  }

  async poll() {
    this.attempts += 1

    if (this.attempts > this.maxAttemptsValue) {
      this.stopPolling()
      this.setUnlinked()
      return
    }

    try {
      const response = await fetch(this.statusUrlValue, {
        credentials: "same-origin",
        headers: { "Accept": "application/json" },
      })
      const body = await response.json()

      if (response.ok && body.is_linked) {
        this.stopPolling()
        this.setLinked()
      }
    } catch {
      this.setChecking("Checking Heidi account link...")
    }
  }

  stopPolling() {
    if (this.timer) window.clearInterval(this.timer)
    this.timer = null
  }

  setChecking(label = "Checking Heidi...") {
    if (!this.hasButtonTarget) return

    this.state = "checking"
    this.buttonTarget.disabled = true
    this.buttonTarget.value = label
  }

  setLinked() {
    if (!this.hasButtonTarget) return

    this.state = "linked"
    this.buttonTarget.disabled = false
    this.buttonTarget.value = "Save and launch Heidi"
  }

  setUnlinked() {
    if (!this.hasButtonTarget) return

    this.state = "unlinked"
    this.buttonTarget.disabled = false
    this.buttonTarget.value = "Link Heidi account"
  }

  setUnavailable() {
    if (!this.hasButtonTarget) return

    this.state = "unavailable"
    this.buttonTarget.disabled = true
    this.buttonTarget.value = "Heidi unavailable"
  }
}
