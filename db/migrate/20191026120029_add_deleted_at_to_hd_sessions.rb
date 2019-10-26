class AddDeletedAtToHDSessions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :hd_sessions, :deleted_at, :datetime
      add_index :hd_sessions, :deleted_at

      add_column :hd_prescription_administrations, :deleted_at, :datetime
      add_index :hd_prescription_administrations, :deleted_at
    end
  end
end
