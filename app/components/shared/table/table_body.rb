# frozen_string_literal: true

class Shared::TableBody < Shared::Base
  def view_template(&)
    tbody(**attrs, &)
  end
end
