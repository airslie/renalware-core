class AddExternalIdToHDSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_sessions, :external_id, :bigint
    add_index :hd_sessions, :external_id, unique: true
  end
end
