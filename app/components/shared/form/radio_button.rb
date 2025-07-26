# frozen_string_literal: true

class Shared::RadioButton < Shared::Base
  def view_template
    input(**attrs)
  end

  private

  def default_attrs
    {
      type: "radio"
    }
  end
end
