class AddUuidToHDSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_sessions, :uuid, :uuid, default: 'uuid_generate_v4()', null: false
    add_index :hd_sessions, :uuid
  end
end
