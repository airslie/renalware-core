# frozen_string_literal: true

module Shared
  class TableBody < Base
    def view_template(&)
      tbody(**attrs, &)
    end
  end
end
