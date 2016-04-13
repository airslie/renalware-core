require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Reponsible for rendering a HTML table for recent observation results.
    #
    class HTMLRecentTableView < SimpleDelegator
      def render(view_model)
        content_tag(:table, id: "observations") do
          format_body(view_model)
        end
      end

      private

      def format_body(rows)
        rows.each do |row|
          header, *values = row
          concat(content_tag(:tr) do
            format_row(header, values)
          end)
        end
      end

      def format_row(header, values)
        content_tag(:td, title: header.title) do
          concat(header)
          values.each do |cell|
            concat(format_cell(cell))
          end
        end
      end

      def format_cell(cell)
        content_tag(:td, cell, class: cell.html_class)
      end
    end
  end
end
