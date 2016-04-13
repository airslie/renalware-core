require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationsController < Pathology::BaseController
      before_filter :load_patient

      class HTMLRecentTableView
        def initialize(context)
          @context = context
        end

        def render(rows)
          h.content_tag(:table, id: "observations") do
            format_body(rows)
          end
        end

        private

        def format_body(rows)
         rows.each do |row|
           header, *values = row
           h.concat(h.content_tag(:tr) do
              h.content_tag(:td, title: header.title) do
                h.concat(header)
                values.each do |cell|
                  h.concat(h.content_tag(:td, cell, class: cell.html_class))
                end
              end
           end)
         end
        end

        def h
          @context
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
