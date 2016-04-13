require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for rendering a HTML table to format historical observation results.
    #
    class HTMLHistoricalTableView < SimpleDelegator
      def render(view_model)
        header, *body = view_model

        content_tag(:table, id: "observations") do
          concat(format_header(header))
          concat(format_body(body))
        end
      end

      private

      def format_header(cells)
        content_tag(:thead) do
          content_tag(:tr) do
            cells.each do |cell|
              concat(format_header_cell(cell))
            end
          end
        end
      end

      def format_body(rows)
        content_tag(:body) do
          rows.each do |cell|
            concat(content_tag(:tr) do
              cell.each do |cell|
                concat(format_body_cell(cell))
              end
            end)
          end
        end
      end

      def format_header_cell(cell)
        content_tag(:th, cell, class: cell.html_class, title: cell.title)
      end

      def format_body_cell(cell)
        content_tag(:td, cell, class: cell.html_class)
      end
    end
  end
end
