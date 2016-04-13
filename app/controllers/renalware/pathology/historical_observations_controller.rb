require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      class HTMLHistoricalTableView
        def initialize(context)
          @context = context
        end

        def render(rows)
          header, *body = rows

          h.content_tag(:table, id: "observations") do
            h.concat format_header(header)
            h.concat format_body(body)
          end
        end

        private

        def format_header(cells)
          h.content_tag(:thead) do
            h.content_tag(:tr) do
              cells.each do |cell|
                h.concat(h.content_tag(:th, cell, class: cell.html_class, title: cell.title))
              end
            end
          end
        end

        def format_body(rows)
          h.content_tag(:body) do
            rows.each do |row|
              h.concat(h.content_tag(:tr) do
                row.each do |cell|
                  h.concat(h.content_tag(:td, cell, class: cell.html_class))
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
