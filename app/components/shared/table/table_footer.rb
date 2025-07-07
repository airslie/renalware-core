# frozen_string_literal: true

module Shared
  class TableFooter < Base
    def view_template(&)
      tfoot(**attrs, &)
    end
  end
end
