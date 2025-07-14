# frozen_string_literal: true

class Shared::TableDetailRow < Shared::TableRow
  def initialize(num_columns, **attrs)
    @num_columns = num_columns
    super(**attrs)
  end

  def view_template(&)
    super do
      TableCell()
      TableCell(colspan: @num_columns - 1) do
        div(class: "text-sm", &)
      end
    end
  end

  private

  def default_attrs = mix(super, class: "hidden")
end
