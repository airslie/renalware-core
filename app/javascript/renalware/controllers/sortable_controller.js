import { Controller } from "@hotwired/stimulus"
import { Sortable } from "sortablejs"

//
// Inspired by https://gorails.com/episodes/rails-drag-and-drop-sortable
//
// Annotate html as follows:
//
// <div data-controller="sortable" data-sortable-url=move_some_resource_path(id: ":id")>
//   <% items.each do |item| %>
//     <div data-id=item.id>...</div>
//   <% end %>
// </div>

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      handle: ".handle",
      animation: 150,
      onEnd: this.end.bind(this),
    })
  }

  end(event) {
    const url = this.data.get("url")

    // No direct server persistance
    if (!url) return

    let id = event.item.dataset.id
    let data = new FormData()
    data.append("position", event.newIndex + 1)

    Rails.ajax({
      url: url.replace(":id", id),
      type: "PATCH",
      data: data,
    })
  }
}
