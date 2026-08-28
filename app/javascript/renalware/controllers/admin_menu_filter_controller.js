import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["query", "item", "group", "clear", "status"]

  connect() {
    this.searching = false
    this.openStates = new Map()
  }

  filter() {
    const terms = this.normalizedTerms(this.queryTarget.value)
    const hasQuery = terms.length > 0

    if (hasQuery && !this.searching) this.rememberOpenSections()

    let matchCount = 0
    this.itemTargets.forEach((item) => {
      const matches = terms.every((term) =>
        this.normalize(item.dataset.searchText).includes(term)
      )
      item.hidden = hasQuery && !matches
      if (!item.hidden) matchCount += 1
    })

    this.groupTargets.forEach((group) => {
      const hasVisibleItems = this.visibleItemsIn(group).length > 0
      group.hidden = hasQuery && !hasVisibleItems

      if (hasQuery) {
        group.querySelector("details").open = hasVisibleItems
      }
    })

    if (!hasQuery && this.searching) this.restoreOpenSections()

    this.searching = hasQuery
    this.clearTarget.hidden = !hasQuery
    this.updateStatus(hasQuery, matchCount)
  }

  clear(event) {
    event?.preventDefault()
    this.queryTarget.value = ""
    this.filter()
    this.queryTarget.focus()
  }

  focusShortcut(event) {
    if (event.key !== "/" || event.metaKey || event.ctrlKey || event.altKey) return
    if (["INPUT", "TEXTAREA", "SELECT"].includes(document.activeElement?.tagName)) return

    event.preventDefault()
    this.queryTarget.focus()
  }

  rememberOpenSections() {
    this.openStates = new Map(
      this.groupTargets.map((group) => {
        const details = group.querySelector("details")
        return [details, details.open]
      })
    )
  }

  restoreOpenSections() {
    this.openStates.forEach((open, details) => {
      details.open = open
    })
  }

  visibleItemsIn(group) {
    return this.itemTargets.filter((item) => group.contains(item) && !item.hidden)
  }

  updateStatus(hasQuery, matchCount) {
    this.statusTarget.hidden = !hasQuery
    if (!hasQuery) {
      this.statusTarget.textContent = ""
    } else if (matchCount === 0) {
      this.statusTarget.textContent = "No matching menu items"
    } else {
      const noun = matchCount === 1 ? "result" : "results"
      this.statusTarget.textContent = `${matchCount} ${noun}`
    }
  }

  normalizedTerms(value) {
    return this.normalize(value).split(/\s+/).filter(Boolean)
  }

  normalize(value = "") {
    return value
      .normalize("NFKD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
  }
}
