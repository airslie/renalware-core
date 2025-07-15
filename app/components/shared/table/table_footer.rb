# frozen_string_literal: true

class Shared::TableFooter < Shared::Base
  def view_template(&)
    tfoot(**attrs, &)
  end
end
