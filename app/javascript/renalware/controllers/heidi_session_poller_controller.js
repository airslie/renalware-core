import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lastChecked", "noteStatus", "status", "trix"]

  static values = {
    interval: { type: Number, default: 10000 },
    insertedSessionIds: { type: Array, default: [] },
    url: String,
  }

  connect() {
    this.poll()
    this.timer = window.setInterval(() => this.poll(), this.intervalValue)
  }

  disconnect() {
    this.stopPolling()
  }

  async poll() {
    try {
      const response = await fetch(this.urlValue, {
        credentials: "same-origin",
        headers: { "Accept": "application/json" },
      })
      if (!response.ok) return

      const body = await response.json()
      if (!body.present) return

      this.updateStatus(body)
      if (body.synced) this.handleSyncedSession(body)
      if (body.status === "sync_failed") this.stopPolling()
    } catch {
      // Keep polling; transient failures should not disturb the edit form.
    }
  }

  updateStatus(body) {
    if (this.hasStatusTarget) this.statusTarget.innerHTML = this.statusBadgeHtml(body)
    if (this.hasNoteStatusTarget) this.noteStatusTarget.textContent = body.consult_note_status
    if (this.hasLastCheckedTarget) this.lastCheckedTarget.textContent = body.last_synced_at
  }

  statusBadgeHtml(body) {
    const status = this.statusClassName(body.status)
    if (!status) return this.escapeHtml(body.status_label)

    return `<span class="heidi-state ${status}"><span class="heidi-state__indicator"></span><span class="heidi-state__label">${this.escapeHtml(body.status_label)}</span></span>`
  }

  statusClassName(status) {
    return {
      "launched": "heidi-state--launched",
      "synced": "heidi-state--synced",
      "sync_failed": "heidi-state--sync-failed",
    }[status]
  }

  handleSyncedSession(body) {
    this.appendConsultNote(body)
    this.stopPolling()
  }

  appendConsultNote(body) {
    if (!this.shouldAppendConsultNote(body)) return

    this.insertedSessionIdsValue = [...this.insertedSessionIdsValue, body.id]
    this.trixTarget.editor.insertHTML(this.formattedConsultNote(body.consult_note))
  }

  shouldAppendConsultNote(body) {
    if (!this.hasTrixTarget) return false
    if (!this.trixTarget.editor) return false
    if (!body.consult_note) return false
    if (this.insertedSessionIdsValue.includes(body.id)) return false

    return !this.currentNoteHtml().includes(body.consult_note)
  }

  formattedConsultNote(note) {
    return `<p><strong>Heidi consult note:</strong></p>${note}`
  }

  currentNoteHtml() {
    return this.trixTarget.value || ""
  }

  escapeHtml(value) {
    const div = document.createElement("div")
    div.textContent = value || ""
    return div.innerHTML
  }

  stopPolling() {
    if (this.timer) window.clearInterval(this.timer)
    this.timer = null
  }
}
