class AddDeletedAtToEvents < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :events, :deleted_at, :datetime
      add_index :events, :deleted_at
    end
  end
end
