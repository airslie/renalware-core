class UpdateAuditLettersAuthorsToVersion3 < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      update_view :reporting_main_authors_audit,
                  materialized: true,
                  version: 3,
                  revert_to_version: 2

      reversible do |direction|
        direction.up {
          connection.execute("refresh materialized view reporting_main_authors_audit;")
        }
        direction.down {
          connection.execute("refresh materialized view reporting_main_authors_audit;")
        }
      end
    end
  end
end
