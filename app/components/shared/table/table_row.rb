# frozen_string_literal: true

module Shared
  class TableRow < Base
    def view_template(&)
      tr(**attrs, &)
    end
  end
end
