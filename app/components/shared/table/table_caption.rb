# frozen_string_literal: true

module Shared
  class TableCaption < Base
    def view_template(&)
      caption(**attrs, &)
    end
  end
end
