class AllowNullStartTimeOnHDSessions < ActiveRecord::Migration
  def change
    change_column :hd_sessions, :start_time, :time, null: true
  end
end
