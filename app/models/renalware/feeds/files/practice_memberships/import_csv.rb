# frozen_string_literal: true

require_dependency "renalware/feeds"
require "attr_extras"

module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        class ImportCSV
          pattr_initialize :csv_path

          def call
            import_practice_memberships_csv_using_sql_function
          end

          private

          # See migration for SQL function definition
          def import_practice_memberships_csv_using_sql_function
            conn = ActiveRecord::Base.connection
            conn.execute(
              "SELECT renalware.import_practice_memberships_csv(
                #{conn.quote(csv_path.realpath.to_s)}::text
              )"
            )
          end
        end
      end
    end
  end
end
