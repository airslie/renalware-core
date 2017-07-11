class UpdateAuditLettersAuthorsToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :reporting_main_authors_audit,
                materialized: true,
                version: 2,
                revert_to_version: 1
  end
end
