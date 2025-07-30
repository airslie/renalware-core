# frozen_string_literal: true

class Shared::Button < Shared::Base
  def initialize(**attrs)
    @type = attrs.delete(:type)

    super(
      **mix(
        if @type == :link
          { class: "btn btn-secondary" }
        else
          { type: "submit", class: "btn btn-primary" }
        end,
        attrs
      )
    )
  end

  def view_template(&)
    if @type == :link
      a(**attrs, &)
    else
      input(**attrs)
    end
  end
end
