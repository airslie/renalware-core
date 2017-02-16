class AddSignedOffAtToHDSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :hd_sessions, :signed_off_at, :datetime, null: true
  end
end
