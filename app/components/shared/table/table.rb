# frozen_string_literal: true

module Shared
  class Table < Base
    def view_template(&)
      table(**attrs, &)
    end
  end
end
