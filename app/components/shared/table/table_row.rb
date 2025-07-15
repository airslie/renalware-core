# frozen_string_literal: true

class Shared::TableRow < Shared::Base
  def view_template(&)
    tr(**attrs, &)
  end
end
