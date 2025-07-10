# frozen_string_literal: true

class Shared::RowTogglerCell < Shared::TableCell
  def view_template(&)
    super do
      a(
        href: "#",
        data: { action: "click->toggle#row", turbo: "false" },
        class: "toggler",
        title: "Toggle"
      ) { i }
    end
  end

  private

  def default_attrs = super.merge(class: "noprint")
end
