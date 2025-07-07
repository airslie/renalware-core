# frozen_string_literal: true

module Shared
  class DescriptionList < Base
    def view_template(&)
      dl(**attrs, &)
    end

    private

    def default_attrs
      { class: "dl-horizontal" }
    end
  end
end
