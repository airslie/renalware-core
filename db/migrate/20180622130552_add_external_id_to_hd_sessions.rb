class AddExternalIdToHDSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_sessions, :external_id, :bigint, index: true
  end
end
