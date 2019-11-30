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

    def th_toggle_all_rows
      content_tag(:th, class: "noprint togglers") do
        table_toggler(link_title: "Toggle all rows")
      end
    end

    def td_toggle_row(row_selector)
      content_tag(:td, class: "noprint") do
        toggler(row_selector)
      end
    end

    # Create a link in a thead > tr > th that will toggle the last row in all tbodies in the table.
    def rows_toggler(link_title: "Toggle all rows")
      link_to(
        "#",
        data: { action: "row-toggler#toggleTable" },
        class: "toggler",
        title: link_title
      ) do
        content_tag(:i)
      end
    end

    # Create a link to be used in a tbody > tr > td that will toggle the last row in the current
    # tbody.
    def row_toggler(link_title: "Toggle")
      link_to(
        "#",
        data: { action: "row-toggler#toggleRow" },
        class: "toggler",
        title: link_title
      ) do
        content_tag(:i)
      end
    end
  end
end
