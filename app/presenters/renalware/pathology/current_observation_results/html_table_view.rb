require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Reponsible for rendering a HTML table for recent observation results.
    #
    class CurrentObservationResults::HTMLTableView < SimpleDelegator
      def render(view_model)
        header, *body = view_model

        content_tag(:div) do
          slice_size =  calculate_slice_size(body.size)
          body.each_slice(slice_size) do |partial_body|
            concat(build_table(header, partial_body))
          end
        end
      end

      private

      def calculate_slice_size(number)
        (number.to_f / number_of_columns).ceil
      end

      def number_of_columns
       3
      end

      def build_table(header, body)
        content_tag(:table, id: "observations", class: "current-observations") do
          concat(format_header(header))
          concat(format_body(body))
        end
      end

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
        content_tag(:tbody) do
          rows.each do |row|
            concat(content_tag(:tr) do
              row.each do |cell|
                concat(format_body_cell(cell))
              end
            end)
          end
        end
      end

      def format_header_cell(cell)
        content_tag(:th, cell)
      end

      def format_body_cell(cell)
        content_tag(:td, cell.content)
      end
    end
  end
end
