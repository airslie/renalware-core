require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationsController < Pathology::BaseController
      before_filter :load_patient

      class HTMLRecentTableView < SimpleDelegator
        def render(rows)
          content_tag(:table, id: "observations") do
            format_body(rows)
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

      def index
        presenter = ViewRecentObservationsFactory.new.build(@patient).call(params)

        render :index, locals: {
          rows: presenter.present,
          number_of_records: presenter.limit,
          table: HTMLRecentTableView.new(self.view_context)
        }
      end
    end
  end
end
