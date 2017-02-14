class AllowNullStartTimeOnHDSessions < ActiveRecord::Migration[4.2]
  def change
    change_column :hd_sessions, :start_time, :time, null: true
  end
end
