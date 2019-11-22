# frozen_string_literal: true

module Renalware
  module ToggleHelper
    def css_toggle_link_to(row_selector:, link_title: "Toggle")
      link_to link_title,
              "#{row_selector} .css-toggle-container",
              class: "button compact low-key",
              data: { behaviour: "css-toggler" }
    end

    def toggler(row_selector, link_title: "Toggle")
      link_to(
        row_selector,
        data: { behaviour: "toggler" },
        class: "toggler",
        title: link_title
      ) do
        content_tag(:i)
      end
    end

    def table_toggler(link_title: "Toggle all rows")
      link_to(
        "#",
        data: { behaviour: "table-toggler" },
        class: "toggler",
        title: link_title
      ) do
        content_tag(:i)
      end
    end
  end
end
