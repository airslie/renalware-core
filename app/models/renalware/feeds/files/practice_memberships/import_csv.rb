require "csv"

module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        class ImportCSV
          pattr_initialize :csv_path

          CSV_HEADER_MAP = {
            gp_code: 0,
            practice_code: 1,
            xxx: 2,
            joined_on: 3,
            left_on: 4,
            unused: 5
          }.freeze

          def call
            batch_import_csv_rows_into_feed_practice_memberships_table
            import_feed_practice_gps_using_sql_function
          end

          private

          def batch_import_csv_rows_into_feed_practice_memberships_table
            Feeds::PracticeGP.delete_all

            CSV.foreach(csv_path.realpath, headers: false).each_slice(1000) do |rows|
              Feeds::PracticeGP.insert_all!(rows.map { |row| attributes_from(row) })
            end
          end

          def attributes_from(row)
            map = CSV_HEADER_MAP
            {
              gp_code: row[map[:gp_code]],
              practice_code: row[map[:practice_code]],
              joined_on: parse_date(row[map[:joined_on]]),
              left_on: parse_date(row[map[:left_on]])
            }
          end

          def parse_date(value)
            Date.parse(value) if value.to_i >= 100
          end

          # See db/functions/import_feed_practice_gps_v03.sql
          # Using a SQL fn here as originally there was quite a bit of SQL involved.
          # Could move this to Ruby.
          def import_feed_practice_gps_using_sql_function
            ActiveRecord::Base.connection.execute("SELECT renalware.import_feed_practice_gps()")
          end
        end
      end
    end
  end
end
