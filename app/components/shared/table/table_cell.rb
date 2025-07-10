# frozen_string_literal: true

class Shared::TableCell < Shared::Base
  def view_template(&)
    td(**attrs, &)
  end
end
