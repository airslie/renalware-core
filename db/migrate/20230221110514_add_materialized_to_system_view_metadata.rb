class AddMaterializedToSystemViewMetadata < ActiveRecord::Migration[6.0]
  def change
    add_column :system_view_metadata, :materialized, :boolean, default: false, null: false
    add_column :system_view_metadata, :materialized_view_refreshed_at, :datetime
  end
end
