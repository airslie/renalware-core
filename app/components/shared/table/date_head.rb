# frozen_string_literal: true

class Shared::DateHead < Shared::TableHead
  def initialize(**attrs)
    super(**mix({ class: "col-width-date" }, attrs))
  end

  def view_template
    super { "Date" }
  end
end
