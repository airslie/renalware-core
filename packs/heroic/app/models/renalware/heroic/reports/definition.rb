# frozen_string_literal: true

require "csv"

module Renalware
  module Heroic
    module Reports
      class Definition < ApplicationRecord
        # Render a report (a SQL view) to csv, including headers.
        # We create a temp AR model to wrap the SQL view - this lets us call #all to return all
        # rows, and importantly will map any dates or times to their locale-specific values.
        # While we could create static rb files for each report, using a dynamic class lets us
        # add reports (by defining the view and adding it to the report_defnitions table)
        # without changing any code.
        # The previous implementation here used connection.raw_connection.copy_data to stream the
        # CSV to STDOUT with the help of postgres - this was very fast, but left dates in UTC.
        # For reference that solution was inspired by
        # https://shift.infinite.red/fast-csv-report-generation-with-postgres-in-rails-d444d9b915ab
        # The current approach here is more memory hungry for large reports as it builds a CSV
        # string, but is more Rails-y and locale friendly.
        # rubocop:disable Rails/FindEach
        def to_csv
          klass = Class.new(ApplicationRecord)
          klass.table_name = report_view_name

          CSV.generate do |csv|
            csv << klass.column_names
            klass.all.each do |row|
              csv << row.attributes.values.map { |val| format_value(val) }
            end
          end
        end
        # rubocop:enable Rails/FindEach

        # Map Time values to e.g. "2018-01-01 12:01" and Dates to e.g. "2018-01-01"
        def format_value(val)
          val.respond_to?(:strftime) ? I18n.l(val) : val
        end
      end
    end
  end
end
