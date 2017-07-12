class RemoveSiteFromAccessProcedures < ActiveRecord::Migration[5.0]
  def up
    remove_column :access_procedures, :site_id
  end

  def down
    add_reference :access_procedures, :site, null: true, index: true
    add_foreign_key :access_procedures, :access_sites, column: :site_id
  end
end
