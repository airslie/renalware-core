require_dependency "renalware/feeds"
require "attr_extras"

module Renalware
  module Feeds
    module Files
      module PrimaryCarePhysicians
        class ImportCSV
          pattr_initialize :csv_path

          def call
            import_practices_csv_using_sql_function
          end

          private

          # See migration for SQL function definition
          def import_practices_csv_using_sql_function
            conn = ActiveRecord::Base.connection
            conn.execute(
              "SELECT renalware.import_gps_csv(#{conn.quote(csv_path.realpath.to_s)}::text)"
            )
          end
        end
      end
    end
  end
end
