# frozen_string_literal: true

module Shared
  class TableHead < Base
    def view_template(&)
      th(**attrs, &)
    end
  end
end
