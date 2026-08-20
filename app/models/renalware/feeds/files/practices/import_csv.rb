require "csv"

module Renalware
  module Feeds
    module Files
      module Practices
        class ImportCSV
          pattr_initialize :csv_path

          CSV_HEADER_MAP = {
            code: 0,
            name: 1,
            street_1: 4,
            street_2: 5,
            street_3: 6,
            town: 7,
            county: 8,
            postcode: 9,
            status: 12,
            telephone: 17
          }.freeze

          def call
            batch_import_csv_rows_into_feed_practices_table
            ActiveRecord::Base.connection.execute("SELECT renalware.import_feed_practices()")
          end

          private

          def batch_import_csv_rows_into_feed_practices_table
            Feeds::Practice.delete_all

            CSV.foreach(csv_path.realpath, headers: false).each_slice(1000) do |rows|
              Feeds::Practice.insert_all!(rows.map { |row| attributes_from(row) })
            end
          end

          def attributes_from(row)
            CSV_HEADER_MAP.to_h { |attribute, index| [attribute, row[index]] }.tap do |attributes|
              attributes[:status] = attributes[:status].to_s.upcase
            end
          end
        end
      end
    end
  end
end
