# frozen_string_literal: true

module Shared
  class TableCell < Base
    def view_template(&)
      td(**attrs, &)
    end
  end
end
