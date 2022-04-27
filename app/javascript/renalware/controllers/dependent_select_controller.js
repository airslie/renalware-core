import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "target" ]

  handleSelectChange() {
    this.populateSelect(this.sourceTarget.value)
  }

  populateSelect(sourceId, targetId = null) {
    fetch(`/${this.data.get("sourceRoutePart")}/${sourceId}/${this.data.get("targetRoutePart")}.json`, {
      credentials: "same-origin"
    })
      .then(response => response.json())
      .then(data => {
        const selectBox = this.targetTarget
        selectBox.innerHTML = ""
        selectBox.appendChild(document.createElement("option")) // blank option
        data.forEach(item => {
          const opt = document.createElement("option")
          opt.value = item.id
          opt.innerHTML = item[this.data.get("displayAttribute")]
          opt.selected = parseInt(targetId) === item.id
          selectBox.appendChild(opt)
        })
      })
  }
}
