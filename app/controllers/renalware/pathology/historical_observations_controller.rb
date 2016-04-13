require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      class HTMLHistoricalTableView < SimpleDelegator
        def render(rows)
          header, *body = rows

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
                concat(content_tag(:th, cell, class: cell.html_class, title: cell.title))
              end
            end
          end
        end

        def format_body(rows)
          content_tag(:body) do
            rows.each do |row|
              concat(content_tag(:tr) do
                row.each do |cell|
                  concat(content_tag(:td, cell, class: cell.html_class))
                end
              end)
            end
          end
        end

        def h
          @context
        end
      end

      def index
        presenter = ViewHistoricalObservationsFactory.new.build(@patient).call(params)

        render :index, locals: {
          rows: presenter.present,
          paginator: presenter.paginator,
          table: HTMLHistoricalTableView.new(self.view_context)
        }
      end
    end
  end
end
