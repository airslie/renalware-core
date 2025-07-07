# frozen_string_literal: true

module Shared
  class TableHeader < Base
    def view_template(&)
      thead(**attrs, &)
    end
  end
end
