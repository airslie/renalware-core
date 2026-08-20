require "csv"

module Renalware
  module Feeds
    module Files
      module PrimaryCarePhysicians
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
            status: 12, # A = Active B = Retired C = Closed P = Proposed
            telephone: 17,
            amended_record_indicator: 21
          }.freeze
          LEGACY_STATUSES = {
            "A" => "ACTIVE",
            "B" => "RETIRED",
            "C" => "INACTIVE",
            "P" => "PROPOSED"
          }.freeze

          # 1. Import in batches into a new tmp table - what would the fn have used?
          def call
            batch_import_csv_rows_into_feed_gp_table
            import_feed_gps_using_sql_function
          end

          private

          # There are about 100,000 GPs in the UK
          # rubocop:disable Lint/AssignmentInCondition, Metrics/AbcSize
          def batch_import_csv_rows_into_feed_gp_table
            Feeds::GP.delete_all

            ::File.open(csv_path.realpath.to_s, "r") do |file|
              csv = CSV.new(file, headers: false)
              gps = []
              map = CSV_HEADER_MAP
              while row = csv.shift
                gps << {
                  code: row[map[:code]],
                  name: row[map[:name]],
                  street_1: row[map[:street_1]],
                  street_2: row[map[:street_2]],
                  street_3: row[map[:street_3]],
                  town: row[map[:town]],
                  county: row[map[:county]],
                  postcode: row[map[:postcode]],
                  telephone: row[map[:telephone]],
                  status: normalize_status(row[map[:status]])
                }

                if gps.size == 1000
                  Feeds::GP.insert_all!(gps)
                  gps.clear
                end
              end

              Feeds::GP.insert_all!(gps) if gps.any?
            end
          end
          # rubocop:enable Lint/AssignmentInCondition, Metrics/AbcSize

          def normalize_status(status)
            status = status.to_s.upcase
            LEGACY_STATUSES.fetch(status, status)
          end

          # See migration for SQL function definition
          def import_feed_gps_using_sql_function
            conn = ActiveRecord::Base.connection
            conn.execute("SELECT renalware.import_feed_gps()")
          end
        end
      end
    end
  end
end
