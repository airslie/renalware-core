# frozen_string_literal: true

require_dependency "renalware/feeds"
require "attr_extras"

module Renalware
  module Feeds
    module Files
      module Practices
        class ImportCSV
          pattr_initialize :csv_path

          def call
            Rails.logger.info("Importing CSV file #{csv_path}...")
            import_practices_csv_using_sql_function
            Rails.logger.info("... done")
          end

          private

          # See migration for SQL function definition
          def import_practices_csv_using_sql_function
            conn = ActiveRecord::Base.connection
            conn.execute(
              "SELECT import_practices_csv(#{conn.quote(csv_path.realpath.to_s)})"
            )
          end
        end
      end
    end
  end
end
