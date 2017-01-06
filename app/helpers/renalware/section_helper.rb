module Renalware
  module SectionHelper

    def section(title:)
      content_tag(:section, class: "display") do
        concat content_tag(:h4) { title }
        yield if block_given?
      end
    end
  end
end
