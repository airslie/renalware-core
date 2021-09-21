# frozen_string_literal: true

require_dependency "renalware/feeds"

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
          }

          def call
            batch_import_csv_rows_into_feed_practice_memberships_table
            import_feed_practice_gps_using_sql_function
          end

          private

          def batch_import_csv_rows_into_feed_practice_memberships_table
            Feeds::PracticeGp.delete_all

            ::File.open(csv_path.realpath.to_s, 'r') do |file|
              csv = CSV.new(file, headers: false)
              rows = []
              map = CSV_HEADER_MAP
              while row = csv.shift
                joined_on = row[map[:joined_on]]
                left_on = row[map[:left_on]]

                if joined_on.to_i < 100
                  joined_on = nil
                end

                if left_on.to_i < 100
                  left_on = nil
                end

                rows << Feeds::PracticeGp.new(
                  gp_code: row[map[:gp_code]],
                  practice_code: row[map[:practice_code]],
                  joined_on: joined_on.presence && Date.parse(joined_on),
                  left_on: left_on.presence && Date.parse(left_on)
                )
              end

              # Make about 100 insert queries each with 1000 records
              Feeds::PracticeGp.import!(rows, batch_size: 1000)
            end
          end

          # See migration for SQL function definition
          def import_feed_practice_gps_using_sql_function
            conn = ActiveRecord::Base.connection
            conn.execute("SELECT renalware.import_feed_practice_gps()")
          end
        end
      end
    end
  end
end
